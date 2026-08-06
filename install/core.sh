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
echo -e "${GREEN} ===== CachyOS Repos Config ======="
echo -e "${BLUE} =================================="

# 1. Clave GPG (Forzando servidor HTTP vía puerto 80 para evitar bloqueos)
echo "-> Importando y firmando llaves GPG de CachyOS..."
pacman-key --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys F3B607488DB35A47 || true
pacman-key --lsign-key F3B607488DB35A47

# 2. Instalación de paquetes esenciales del repositorio CachyOS
echo "-> Instalando keyring y mirrorlists de CachyOS..."
CACHY_URL="https://mirror.cachyos.org/repo/x86_64/cachyos"

pacman -U --noconfirm \
  "${CACHY_URL}/cachyos-keyring-20240331-1-any.pkg.tar.zst" \
  "${CACHY_URL}/cachyos-mirrorlist-27-1-any.pkg.tar.zst" \
  "${CACHY_URL}/cachyos-v3-mirrorlist-27-1-any.pkg.tar.zst" \
  "${CACHY_URL}/cachyos-v4-mirrorlist-27-1-any.pkg.tar.zst"

# 3. Automatización del script de detección de CPU (v3/v4/znver4)
echo "-> Descargando y aplicando configuración de repositorios CachyOS..."
TMP_CACHYDIR=$(mktemp -d)
curl -sSL https://mirror.cachyos.org/cachyos-repo.tar.xz | tar -xJ -C "$TMP_CACHYDIR"

pushd "${TMP_CACHYDIR}/cachyos-repo" >/dev/null

# Comentamos la línea de descarga remota redundante dentro del script para prevenir fallos
sed -i 's/.*pacman-key --recv-keys/# &/' cachyos-repo.sh 2>/dev/null || true

# Ejecutamos la instalación de los repos
./cachyos-repo.sh --install

popd >/dev/null
rm -rf "$TMP_CACHYDIR"

# 4. Sincronización final de la base de datos de pacman
echo "-> Sincronizando bases de datos..."
# pacman -Syu --noconfirm

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ========= Kernel CachyOS ========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

# Detectar qué microcódigo quedó instalado (Intel o AMD) para
# no tener que asumirlo a mano.
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
