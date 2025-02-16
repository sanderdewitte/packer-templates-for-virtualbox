#!/usr/bin/env bash

follow_link() {
  local FILE="$1"
  while [ -L "$FILE" ]; do
    FILE="$(readlink "$FILE")"
  done
  echo "$FILE"
}

cleanup() {
  local EXIT_CODE=$?
  if [ $EXIT_CODE -ne 0 ]; then
    echo ""
    if [ $EXIT_CODE -eq 1 ]; then
      echo -n "Goodbye: "
    else
      echo -n "Error: "
    fi
    echo "$(basename "$0") exited with status ${EXIT_CODE}."
  fi
}

# Catch errors and run cleanup
trap "cleanup" EXIT

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
  echo "Usage: script.sh [OPTIONS] [CONFIG_PATH]"
  echo ""
  echo "Options:"
  echo "  -h, --help    Show this help message and exit."
  echo "  -d, --debug   Run builds in debug mode."
  echo ""
  echo "Arguments:"
  echo "  CONFIG_PATH   Path to the configuration directory."
  echo ""
  echo "Examples:"
  echo "  ./build.sh"
  echo "  ./build.sh --help"
  echo "  ./build.sh --debug"
  echo "  ./build.sh config"
  echo "  ./build.sh custom_config_1"
  echo "  ./build.sh --debug config"
  echo "  ./build.sh --debug custom_config_1"
  exit 0
fi

if [ "$1" == "--debug" ] || [ "$1" == "-d" ]; then
  debug_mode=true
  debug_option="-debug"
  shift
else
  debug_mode=false
  debug_option=""
fi

SCRIPT_PATH=$(realpath "$(dirname "$(follow_link "$0")")")

if [ -n "$1" ]; then
  CONFIG_PATH=$(realpath "$1")
else
  CONFIG_PATH=$(realpath "${SCRIPT_PATH}/config")
fi

menu_message="Select a HashiCorp Packer build for Oracle VirtualBox."

if [ "$debug_mode" = true ]; then
  menu_message+=" \e[31m(Debug Mode)\e[0m"
fi

menu_option_1() {
  INPUT_PATH="$SCRIPT_PATH"/builds/linux/fedora/coreos/
  BUILD_PATH=${INPUT_PATH#"${SCRIPT_PATH}/builds/"}
  BUILD_VARS="$(echo "${BUILD_PATH%/}" | tr -s '/' | tr '/' '-').pkrvars.hcl"

  echo -e "\nCONFIRM: Build a Fedora CoreOS template for Oracle VirtualBox?"
  echo -en "\nContinue? (y/n) "
  read -r REPLY
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi

  ### Build a Fedora CoreOS template for Oracle VirtualBox. ###
  echo -e "\nBuilding a Fedora CoreOS template for Oracle VirtualBox..."

  ### Download Vagrant provided (insecure) private key. ###
  download_insecure_private_key

  ### Initialize HashiCorp Packer and required plugins. ###
  echo "Initializing HashiCorp Packer and required plugins..."
  packer init "$INPUT_PATH"

  ### Start the Build. ###
  echo "Starting the build...."
  echo "packer build -force -on-error=ask $debug_option"
  # shellcheck disable=SC2086
  packer build -use-sequential-evaluation -force -on-error=ask $debug_option \
      -var-file="$CONFIG_PATH/build.pkrvars.hcl" \
      -var-file="$CONFIG_PATH/common.pkrvars.hcl" \
      -var-file="$CONFIG_PATH/network.pkrvars.hcl" \
      -var-file="$CONFIG_PATH/linux-storage.pkrvars.hcl" \
      -var-file="$CONFIG_PATH/$BUILD_VARS" \
      "$INPUT_PATH"

  ### Build Complete. ###
  echo "Build Complete."
}

press_enter() {
  # shellcheck disable=SC2164
  cd "$SCRIPT_PATH"
  echo -n "Press Enter to continue."
  read -r
  clear
}

info() {
  echo "GitLab Repository: https://github.com/sanderdewitte/packer-templates-for-virtualbox"
  echo ""
  echo "License: MIT"
  echo ""
  press_enter
}

incorrect_selection() {
  echo "Invalid selection, please try again."
}

download_insecure_private_key() {
  local VAGRANT_INSECURE_KEY_URL="https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.key.ed25519"
  local LOCAL_PRIVATE_KEY_FILE="/var/tmp/id_ed255129"
  if command -v curl > /dev/null; then
    curl -fsSL -o "$LOCAL_PRIVATE_KEY_FILE" "$VAGRANT_INSECURE_KEY_URL"
  elif command -v wget > /dev/null; then
    wget -q -O "$LOCAL_PRIVATE_KEY_FILE" "$VAGRANT_INSECURE_KEY_URL"
  else
    python3 -c "import urllib.request; urllib.request.urlretrieve(\"$VAGRANT_INSECURE_KEY_URL\", \"$LOCAL_PRIVATE_KEY_FILE\")"
  fi
  if [ -f $LOCAL_PRIVATE_KEY_FILE ]; then
    chmod 600 $LOCAL_PRIVATE_KEY_FILE
  else
    echo "Error: Private key file not downloaded (from \"$VAGRANT_INSECURE_KEY_URL\")." >&2
    exit 2
  fi
}

until [ "$selection" = "0" ]; do
  clear
  echo ""
  echo -e "$menu_message"
  echo ""
  echo "      Linux Distributions:"
  echo ""
  echo "    	1  -  Fedora CoreOS"
  echo ""
  echo "      Other:"
  echo ""
  echo "        i   -  Information"
  echo "        q   -  Quit"
  echo ""
  echo -n "Input: "
  read -r selection
  echo ""
  case $selection in
    1 ) clear ; menu_option_1 ; press_enter ;;
    i|I ) clear ; info ;;
    q|Q ) clear ; exit ;;
    * ) clear ; incorrect_selection ; press_enter ;;
  esac
done
