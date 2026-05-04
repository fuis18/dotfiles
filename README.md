# dotfiles

> Arch Linux · Hyprland · Wayland — built for performance and productivity.

A minimal, fast, keyboard-driven setup. Every tool was chosen intentionally:
no bloat, no eye candy for its own sake — just a system that stays out of
the way and lets you work.

---

## Philosophy

**The shell is the UI.** A fast terminal, a good prompt and smart completions
beat any GUI file manager or launcher. `zsh` + `starship` + `yazi` cover 90%
of daily navigation.

**Audio and notifications should be invisible.** `pipewire` handles audio
without config drama. `swaync` shows what matters and nothing else.

**One tool per job.** No redundancy in the stack — if two packages solve the
same problem, one gets cut.

**Performance first.** `zram` + swappiness tuning, `btop` always available,
`hyprland` for GPU-accelerated compositing with near-zero idle overhead.

---

## Stack

| Role           | Tool                   |
| -------------- | ---------------------- |
| Window Manager | hyprland               |
| Terminal       | kitty                  |
| Shell          | zsh + starship         |
| Editor         | nvim, helix, zed       |
| File Manager   | yazi / spacedrive      |
| Launcher       | anyrun                 |
| Status bar     | ironbar                |
| Notifications  | swaync                 |
| Audio          | pipewire + cava        |
| Bluetooth      | bluez + bluetui        |
| Network        | networkmanager + nmcli |
| Screenshot     | grim + slurp + swappy  |
| Brightness     | brightnessctl          |
| System monitor | btop                   |
| Login Manager  | greetd + tuigreet      |
| Power menu     | wlogout                |

---

## Install

### Connect to the network

```sh
sudo systemctl enable --now NetworkManager
nmcli device wifi connect "SSID" password "password"
```

### Clone and run

```sh
sudo pacman -S git
mkdir -p Downloads/repos/fuis18 && cd Downloads/repos/fuis18
git clone https://github.com/fuis18/dotfiles.git

sudo bash dotfiles/setup.sh
sudo bash dotfiles/setup_post_reboot.sh
```

> For full disk partitioning and bootloader setup, see [SETUP.md](./SETUP.md).
