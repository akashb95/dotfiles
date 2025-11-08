# ============================================ HELPERS ==========================================#

log() {
  local prefix="[link.sh] =>"
  local message="$1"

  # Empty message translates to a newline.
  if [ -z "$message" ] || [ "$message" = "\n" ]; then
    log "" # Print a blank line
  else
    log "$prefix $message\n"
  fi
}

is_debian() {
    # This file is the modern standard for identifying Linux distros
    if [ -f /etc/os-release ]; then
        # We use grep -E (Extended REGEX) to check two conditions:
        # 1. ^ID=debian$ (The ID is exactly 'debian')
        # 2. ^ID_LIKE=.*debian.*$ (The ID_LIKE field *contains* 'debian')
        # This will catch Debian, Ubuntu, Linux Mint, Pop!_OS, etc.
        if grep -qE '^(ID=debian|ID_LIKE=.*debian.*)$' /etc/os-release; then
            log "Debian-based system (e.g., Debian, Ubuntu, Mint) detected via /etc/os-release."
            return 0
        fi

    # Fallback check: /etc/debian_version (for older systems)
    elif [ -f /etc/debian_version ]; then
        log "Debian-based system detected via /etc/debian_version."
        return 0
    fi

    return 1
}

# ============================================ HELPERS ==========================================#

log "Linking Zsh config"
# Use command -v for POSIX compatibility
if command -v zsh >/dev/null; then
    ln -s ~/.config/.zshrc ~/.zshrc
    log "Linked ~/.zshrc."
else
    log "zsh not found, skipping."
fi;

log "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
log "Updating rust"
rustup update
if command -v zsh >/dev/null; then
    log "Sourcing .zshrc to include rust toolchain"
    source ~/.zshrc
else
    log "Sourcing .bashrc to include rust toolchain"
    source ~/.bashrc
fi

log "Installing Yazi"
case "$(uname -s)" in # Detect OS
    Darwin)
        log "macOS detected."
        # Check if Homebrew is installed
        if ! command -v brew >/dev/null; then
            log "Homebrew not found. Please install it first."
            exit 1
        fi

        brew update
        log "❗ Please use brew to install yazi"
        log "❗ Remember to manually install a Nerd Font."
        ;;

    Linux)
        log "Linux detected."
        if !is_debian; then
            log "Non-Debian flavours not supported. Please install dependencies manually."
            exit 1
        fi

        log "Debian/Ubuntu detected. Installing dependencies via apt..."

        sudo apt update

        # Mapped dependencies:
        # sevenzip -> p7zip-full
        # poppler -> poppler-utils
        # fd -> fd-find
        # resvg -> librsvg2-bin
        # Note: fzf is also a dep, but is installed from source.
        sudo apt install -y ffmpeg fzf p7zip-full jq poppler-utils fd-find ripgrep zoxide librsvg2-bin imagemagick

        log "Installing yazi-build crate"
        cargo install --force yazi-build
        ;;

    *)
        log "Unsupported OS: $(uname -s)"
        log "Please install Yazi and dependencies manually."
        ;;
esac

if command -v ya >/dev/null; then
    log "Installing Yazi packages"
    ya pkg add yazi-rs/flavors:dracula
    ya pkg add yazi-rs/flavors:catppuccin-latte

    ya pkg add XYenon/clipboard
    ya pkg add Lil-Dank/lazygit
    ya pkg add yazi-rs/plugins:git
fi

log "Setup complete!"
