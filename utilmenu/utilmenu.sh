#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load configuration
source "$SCRIPT_DIR/config/default.sh"
source "$SCRIPT_DIR/config/user.sh"

# Load core utilities
source "$SCRIPT_DIR/core/registry.sh"
source "$SCRIPT_DIR/core/runner.sh"
source "$SCRIPT_DIR/core/profiles.sh"
source "$SCRIPT_DIR/platform/os.sh"

detect_base_os
detect_system_model

source "$SCRIPT_DIR/platform/packages.sh"

# load commands
for file in "$SCRIPT_DIR/commands/"*.sh; do
  source "$file"
done

# CLI mode
if [[ $# -gt 0 ]]; then
  run_command "$1"
  exit
fi

# Menu mode
source "$SCRIPT_DIR/core/ui.sh"
show_menu