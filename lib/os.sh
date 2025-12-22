#!/usr/bin/env bash
# OS detection helpers
# Usage:
#   source "$DOTFILES/lib/os.sh"
#   os="$(detect_os)"

detect_os() {
    # macOS
    if [[ "$(uname -s)" == "Darwin" ]]; then
        printf '%s\n' "macos"
        return 0
    fi

    # Linux (systemd & non-systemd)
    if [[ -r /etc/os-release ]]; then
        # shellcheck disable=SC1091
        . /etc/os-release

        case "$ID" in
            ubuntu)
                printf '%s\n' "ubuntu"
                ;;
            debian)
                printf '%s\n' "debian"
                ;;
            arch)
                printf '%s\n' "arch"
                ;;
            fedora)
                # uBlue / Bazzite often identify as fedora
                if [[ "$VARIANT_ID" == "bazzite" || "$NAME" =~ uBlue ]]; then
                    printf '%s\n' "ublue"
                else
                    printf '%s\n' "fedora"
                fi
                ;;
            bazzite|ublue-os)
                printf '%s\n' "ublue"
                ;;
            *)
                return 1
                ;;
        esac

        return 0
    fi

    return 1
}

# Convenience helpers (optional but very handy)
is_macos()   { [[ "$(detect_os)" == "macos"   ]]; }
is_ubuntu()  { [[ "$(detect_os)" == "ubuntu"  ]]; }
is_debian()  { [[ "$(detect_os)" == "debian"  ]]; }
is_fedora()  { [[ "$(detect_os)" == "fedora"  ]]; }
is_ublue()   { [[ "$(detect_os)" == "ublue"   ]]; }
is_arch()    { [[ "$(detect_os)" == "arch"    ]]; }
