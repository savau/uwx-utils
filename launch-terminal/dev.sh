#!/usr/bin/env sh

UWX_UTILS_DIR=$(dirname `readlink -f "$0"`)/..

REMOTE_COMMAND="\$SHELL -l"
REMOTE_DIR="~"

DO_CHECK_CONNECTION=false
VERBOSE_MODE=false

source $UWX_UTILS_DIR/utils/config.sh

while true; do
  case $1 in
    --project )
      REMOTE_COMMAND="cd ~/$2; \$SHELL -l"
      shift 2;;
    --nix-shell )
      REMOTE_COMMAND="nix-shell --packages nodejs chromium reuse pre-commit node2nix --command \"zsh -i -is eval 'cd $2'\""
      shift 2;;
    --develop )
      # REMOTE_COMMAND="zsh -i -is eval 'cd $2; develop'"
      REMOTE_COMMAND="nix-shell --packages nodejs chromium reuse pre-commit node2nix --command \"cd $2 && develop\""
      shift 2;;
    --dont-check-connection )
      DO_CHECK_CONNECTION=false
      shift;;
    --verbose )
      VERBOSE_MODE=true
      shift;;
    -- ) shift; break;;
    * )
      # if $VERBOSE_MODE; then
      #   echo "Invalid option: $1"
      # fi
      break;;
  esac
done

if $DO_CHECK_CONNECTION; then
  if $VERBOSE_MODE; then
    echo "Checking connection..."
  fi
  source $UWX_UTILS_DIR/utils/check_connection.sh
  if $VERBOSE_MODE; then
    echo "  ... connection check passed successfully."
  fi
fi

if $VERBOSE_MODE; then
  echo "Opening ssh session to $REMOTE_HOST_SHORT..."
fi

ssh -t $REMOTE_HOST "$REMOTE_COMMAND"
