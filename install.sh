#!/usr/bin/env bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| aelyx-shell         |--/ /-|#
#|-/ /--| Installer           |-/ /--|#
#|/ /---+---------------------+/ /---|#

set -Eeuo pipefail

# ==================================================
# Paths
# ==================================================
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYSTEM_DIR="$ROOT_DIR/system"
PROFILE="${1:-full}"

# ==================================================
# UI Styling
# ==================================================
BOLD="\033[1m"
DIM="\033[2m"
RED="\033[31m"
GREEN="\033[32m"
BLUE="\033[34m"
GRAY="\033[90m"
RESET="\033[0m"

step() { echo -e "${BLUE}==> $*${RESET}"; }
ok()   { echo -e "${GREEN}✔ $*${RESET}"; }
warn() { echo -e "${RED}⚠ $*${RESET}"; }
info() { echo -e "${GRAY}$*${RESET}"; }
err()  { echo -e "${RED}✖ $*${RESET}"; }

# Banner
show_banner() {
    clear
    echo -e "${GREEN}"
    cat <<"EOF"
      ___   _____________  ___
     /   | / ____/ / / / /   |
    / /| |/ __/ / / / / / /| |
   / ___ / /___/ /_/ /|/ ___ |
  /_/  |_/_____/\____//_/  |_|

              aelyx-shell (ae-qs)
       shell environment installer
EOF
    echo -e "${RESET}"
}

# dialog Yes / No toggle
confirm() {
    dialog --clear \
        --title "aelyx-shell installer" \
        --yes-label "Yes" \
        --no-label "No" \
        --yesno "$1" 8 50
}

# Dependency helpers
exists() { command -v "$1" &>/dev/null; }
installed() { pacman -Qs "$1" &>/dev/null; }

# Package lists
FULL_PACKAGES=(
    hyprland hyprpaper hyprlock hyprpicker
    wf-recorder grim slurp
    kitty fish starship
    firefox nautilus
    networkmanager wireplumber bluez-utils
    fastfetch playerctl brightnessctl
    papirus-icon-theme-git
    nerd-fonts ttf-jetbrains-mono
    ttf-fira-code ttf-firacode-nerd
    ttf-material-symbols-variable-git
    ttf-font-awesome ttf-fira-sans
    quickshell matugen-bin
    qt5-wayland qt6-wayland qt5-graphicaleffects qt6-5compat
    xdg-desktop-portal-hyprland
    zenity jq ddcutil flatpak
)

SHELL_PACKAGES=(
    quickshell matugen-bin zenity
    kitty starship fish
    qt5-wayland qt6-wayland qt5-graphicaleffects qt6-5compat
    nerd-fonts ttf-jetbrains-mono
    ttf-fira-code ttf-firacode-nerd
    ttf-material-symbols-variable-git
    ttf-font-awesome ttf-fira-sans
)

PACKAGES=("${FULL_PACKAGES[@]}")
[[ "$PROFILE" == "shell" ]] && PACKAGES=("${SHELL_PACKAGES[@]}")

# yay installer
install_yay() {
    step "Installing yay (AUR helper)"
    sudo pacman -S --needed --noconfirm base-devel git
    tmp="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay.git "$tmp/yay"
    pushd "$tmp/yay" >/dev/null
    makepkg -si --noconfirm
    popd >/dev/null
    rm -rf "$tmp"
    ok "yay installed"
}

# Start
show_banner
warn "This installer will install packages and overwrite configuration files."
info "Installation profile: $PROFILE"
echo

confirm "Continue installation?" || exit 0

# Core dependency check
step "Checking core dependencies"
missing=()
for dep in git stow dialog; do
    exists "$dep" && ok "$dep" || { err "$dep missing"; missing+=("$dep"); }
done

if [[ ${#missing[@]} -gt 0 ]]; then
    echo
    err "Missing dependencies: ${missing[*]}"
    info "Install them with:"
    info "  sudo pacman -S ${missing[*]}"
    exit 1
fi

# yay
step "Checking yay"
if ! exists yay; then
    install_yay
else
    ok "yay already installed"
fi

# Package installation
step "Installing packages"
for pkg in "${PACKAGES[@]}"; do
    if installed "$pkg"; then
        info ":: $pkg already installed"
    else
        echo -e "${BLUE}:: Installing $pkg${RESET}"
        yay -S --noconfirm "$pkg" || {
            err "Failed to install $pkg"
            exit 1
        }
    fi
done
ok "All packages installed"

# Config installation
step "Installing configuration files"

mkdir -p ~/.config ~/.local/share/aelyx

if [[ "$PROFILE" == "full" ]]; then
    cp -r "$SYSTEM_DIR/.config/"* ~/.config/
    cp -r "$SYSTEM_DIR/.local/share/aelyx/"* ~/.local/share/aelyx/
else
    cp -r "$SYSTEM_DIR/.config/quickshell" ~/.config/
    cp -r "$SYSTEM_DIR/.config/matugen" ~/.config/
    cp -r "$SYSTEM_DIR/.local/share/aelyx/"* ~/.local/share/aelyx/
fi

ok "Configuration files installed"

# Boot instructions
clear
show_banner
echo
ok "Installation complete"
info "Log out or reboot for changes to take effect"
info "Welcome to aelyx-shell"
