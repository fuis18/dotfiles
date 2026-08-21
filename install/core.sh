#!/bin/bash

# Handle Errors
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Use sudo, need the root"
  exit 1
fi

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ===== Snapper (Btrfs config) ====="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

# Solo aplica si root es Btrfs y @snapshots quedó registrado en fstab
# (ver SETUP.md). En ext4/GRUB layout esto se salta sin hacer nada.
if findmnt -no FSTYPE / | grep -q btrfs && grep -qE '[[:space:]]/\.snapshots[[:space:]]' /etc/fstab; then
  if [[ -f /etc/snapper/configs/root ]]; then
    echo -e "${GREEN}[!] Config de snapper 'root' ya existe, saltando.${RESET}"
  else
    echo "-> Liberando el punto de montaje /.snapshots"
    umount /.snapshots
    rm -rf /.snapshots

    echo "-> Creando la config real con snapper"
    snapper -c root create-config /
    snapper -c home create-config /home

    echo "-> Descartando el subvolumen que snapper acaba de crear"
    umount /.snapshots
    btrfs subvolume delete /.snapshots
    mkdir -p /.snapshots

    echo "-> Montando el @snapshots definitivo (vía fstab)"
    mount /.snapshots
    chmod 750 /.snapshots

    if ! grep -q '^SNAPPER_CONFIGS="root"' /etc/conf.d/snapper 2>/dev/null; then
      echo 'SNAPPER_CONFIGS="root"' >/etc/conf.d/snapper
    fi

    systemctl enable --now snapper-timeline.timer
    systemctl enable --now snapper-cleanup.timer

    echo -e "${GREEN}[✔] Snapper listo, snap-pac capturará desde aquí.${RESET}"
  fi
else
  echo -e "${GREEN}[!] No es Btrfs o no hay /.snapshots en fstab, saltando snapper.${RESET}"
fi

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ===== Symlinks a ~/.cache ========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

TARGET_USER=${SUDO_USER:-$(whoami)}

if [[ -z "$TARGET_USER" || "$TARGET_USER" == "root" ]]; then
  echo -e "${GREEN}[!] No se detectó SUDO_USER, saltando symlinks a cache.${RESET}"
else
  USER_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)

  enlazar_a_cache() {
    local origen="$1"
    local destino="$2"

    sudo -u "$TARGET_USER" mkdir -p "$destino"

    if [[ -e "$origen" && ! -L "$origen" ]]; then
      echo "Moviendo datos existentes de $origen a $destino..."
      sudo -u "$TARGET_USER" bash -c "mv '$origen'/* '$destino'/ 2>/dev/null; rm -rf '$origen'"
    fi

    if [[ ! -L "$origen" ]]; then
      sudo -u "$TARGET_USER" mkdir -p "$(dirname "$origen")"
      sudo -u "$TARGET_USER" ln -s "$destino" "$origen"
      echo "Symlink creado: $origen -> $destino"
    fi
  }

  enlazar_a_cache "$USER_HOME/.config/BraveSoftware/Brave-Browser/Safe Browsing" "$USER_HOME/.cache/BraveSoftware/Safe Browsing"
  for suf in "" "-shm" "-wal"; do
    enlazar_archivo_a_cache "$USER_HOME/.config/nushell/history.sqlite3${suf}" "$USER_HOME/.cache/nushell/history.sqlite3${suf}"
  done
fi

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ===== CachyOS Repos Config ======="
echo -e "${BLUE} =================================="

# 1. Clave GPG (Forzando servidor HTTP vía puerto 80 para evitar bloqueos)
echo "-> Importando y firmando llaves GPG de CachyOS..."
pacman-key --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys F3B607488DB35A47 || true
pacman-key --lsign-key F3B607488DB35A47

# 2. Instalación limpia usando el script oficial de CachyOS
echo "-> Descargando e instalando repositorios CachyOS..."
TMP_CACHYDIR=$(mktemp -d)
curl -sSL https://mirror.cachyos.org/cachyos-repo.tar.xz | tar -xJ -C "$TMP_CACHYDIR"

pushd "${TMP_CACHYDIR}/cachyos-repo" >/dev/null

# Evitar reconexión redundante a llaves si la red está restringida
sed -i 's/.*pacman-key --recv-keys/# &/' cachyos-repo.sh 2>/dev/null || true

# El script oficial instala keyring, mirrorlists y detecta CPU (v3/v4)
./cachyos-repo.sh --install

popd >/dev/null
rm -rf "$TMP_CACHYDIR"

# 3. Instalación de rate-mirrors, ordenamiento y actualización de DB
echo "-> Instalando cachyos-rate-mirrors y filtrando mirrors caídos..."
pacman -Sy --needed --noconfirm cachyos-rate-mirrors
cachyos-rate-mirrors || true

echo "-> Sincronizando bases de datos de Pacman..."
pacman -Syyu --noconfirm

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ========= Kernel CachyOS ========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

# Detectar qué microcódigo quedó instalado (Intel o AMD) para no tener que asumirlo a mano.
UCODE_IMG=""
if [[ -f /boot/intel-ucode.img ]]; then
  UCODE_IMG="intel-ucode.img"
elif [[ -f /boot/amd-ucode.img ]]; then
  UCODE_IMG="amd-ucode.img"
else
  echo -e "${GREEN}[!] No se encontró intel-ucode.img ni amd-ucode.img en /boot.${RESET}"
fi

# Kernel linux-cachyos (EEVDF, estándar) + headers para que
# los módulos DKMS (v4l2loopback, etc.) también compilen para él.
pacman -S --needed --noconfirm linux-cachyos linux-cachyos-headers

ARCH_ENTRY="/boot/loader/entries/arch.conf"
CACHY_ENTRY="/boot/loader/entries/cachyos.conf"
LOADER_CONF="/boot/loader/loader.conf"

if [[ ! -f "$ARCH_ENTRY" ]]; then
  echo -e "${GREEN}[!] No existe $ARCH_ENTRY, no puedo copiar las 'options' de root. Saltando entrada de CachyOS.${RESET}"
elif [[ -f "$CACHY_ENTRY" ]] && grep -q '^options' "$CACHY_ENTRY" && grep -q '^initrd' "$CACHY_ENTRY"; then
  echo -e "${GREEN}[!] $CACHY_ENTRY ya existe y está completa, saltando.${RESET}"
else
  # Reutilizamos la misma línea "options" (UUID + rootflags) que ya
  # quedó bien armada en arch.conf, así nunca se desincroniza.
  ROOT_OPTIONS=$(grep '^options' "$ARCH_ENTRY")

  {
    echo "title   CachyOS Kernel"
    echo "linux   /vmlinuz-linux-cachyos"
    [[ -n "$UCODE_IMG" ]] && echo "initrd  /${UCODE_IMG}"
    echo "initrd  /initramfs-linux-cachyos.img"
    echo "$ROOT_OPTIONS"
  } >"$CACHY_ENTRY"

  echo "-> Entrada creada en $CACHY_ENTRY"

  # CachyOS queda como default; arch.conf (linux-zen) queda de respaldo
  # en el menú de systemd-boot (F2 / Space al arrancar).
  if [[ -f "$LOADER_CONF" ]]; then
    sed -i 's/^default.*/default  cachyos.conf/' "$LOADER_CONF"
  fi

  echo -e "${GREEN}[✔] CachyOS queda como kernel por defecto, linux-zen sigue disponible en el menú.${RESET}"
fi

mkinitcpio -P
