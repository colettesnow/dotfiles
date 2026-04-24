install_apps() {
  setopt local_options err_return no_unset

  local SRC_DIR="$1"
  local DEST_DIR="${2:-/Applications}"
  local POST_ACTION="${3:-installed}"

  if [[ -z "$SRC_DIR" || ! -d "$SRC_DIR" ]]; then
    echo "Usage: install_apps <source_dir> [dest_dir=/Applications] [post_action=installed|false|<path/name>]"
    return 1
  fi

  # Resolve post-action directory
  local MOVE_DIR=""
  if [[ "$POST_ACTION" == "false" ]]; then
    MOVE_DIR=""
  elif [[ "$POST_ACTION" == "installed" ]]; then
    MOVE_DIR="$SRC_DIR/installed"
  elif [[ "$POST_ACTION" == /* || "$POST_ACTION" == .* ]]; then
    MOVE_DIR="$POST_ACTION"
  else
    MOVE_DIR="$SRC_DIR/$POST_ACTION"
  fi

  [[ -n "$MOVE_DIR" ]] && mkdir -p "$MOVE_DIR"

  for ITEM in "$SRC_DIR"/*; do
    [[ ! -e "$ITEM" ]] && continue

    echo "Processing: $ITEM"

    case "$ITEM" in
      *.app)
        echo "→ Installing app bundle"
        ditto "$ITEM" "$DEST_DIR/$(basename "$ITEM")"
        ;;

      *.dmg)
        echo "→ Mounting DMG"
        VOL=$(hdiutil attach "$ITEM" -nobrowse -quiet | awk '/\/Volumes\// {print $3; exit}')
        if [[ -z "$VOL" ]]; then
          echo "⚠️ Failed to mount $ITEM"
          continue
        fi

        APP=$(find "$VOL" -maxdepth 2 -name "*.app" -print -quit)
        if [[ -n "$APP" ]]; then
          echo "→ Installing $(basename "$APP")"
          ditto "$APP" "$DEST_DIR/$(basename "$APP")"
        else
          echo "⚠️ No .app found in $ITEM"
        fi

        hdiutil detach "$VOL" -quiet
        ;;

      *.zip)
        echo "→ Extracting ZIP"
        TMP_DIR=$(mktemp -d)
        unzip -qq "$ITEM" -d "$TMP_DIR"

        # Look for .app or .dmg inside
        INNER_APP=$(find "$TMP_DIR" -name "*.app" -print -quit)
        INNER_DMG=$(find "$TMP_DIR" -name "*.dmg" -print -quit)

        if [[ -n "$INNER_APP" ]]; then
          echo "→ Installing $(basename "$INNER_APP")"
          ditto "$INNER_APP" "$DEST_DIR/$(basename "$INNER_APP")"

        elif [[ -n "$INNER_DMG" ]]; then
          echo "→ Found DMG inside ZIP"
          VOL=$(hdiutil attach "$INNER_DMG" -nobrowse -quiet | awk '/\/Volumes\// {print $3; exit}')
          APP=$(find "$VOL" -maxdepth 2 -name "*.app" -print -quit)

          if [[ -n "$APP" ]]; then
            echo "→ Installing $(basename "$APP")"
            ditto "$APP" "$DEST_DIR/$(basename "$APP")"
          else
            echo "⚠️ No .app found in inner DMG"
          fi

          hdiutil detach "$VOL" -quiet
        else
          echo "⚠️ No installable content in ZIP"
        fi

        rm -rf "$TMP_DIR"
        ;;

      *)
        echo "↷ Skipping unsupported file: $ITEM"
        continue
        ;;
    esac

    # Post कार्रवाई
    if [[ "$POST_ACTION" == "false" ]]; then
      echo "🗑 Deleting source"
      rm -rf "$ITEM"
    else
      echo "📦 Moving to $MOVE_DIR"
      mv "$ITEM" "$MOVE_DIR/"
    fi

    echo ""
  done
}