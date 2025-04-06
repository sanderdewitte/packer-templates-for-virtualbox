#!/usr/bin/env bash

# Define paths
BASE_DIR=$(dirname "$0")
COREOS_DATA_PATH="builds/linux/fedora/coreos/data"
BUTANE_FILE="${COREOS_DATA_PATH}/config.bu"
IGN_FILE="${COREOS_DATA_PATH}/config.ign"
TEMPLATE_FILE="${COREOS_DATA_PATH}/config.ign.pkrtpl.hcl"

# Ensure Butane file exists
if [ ! -f "$BASE_DIR/$BUTANE_FILE" ]; then
  echo "Error: Butane source file ($(basename $BUTANE_FILE)) not found."
  exit 1
fi

# Transform Butane to Ignition using Butane Docker image
echo "Converting $(basename $BUTANE_FILE) to $(basename $IGN_FILE) using Butane..."
docker run --rm -i \
  -v "$BASE_DIR:/workspace" \
  quay.io/coreos/butane:release \
  --pretty --strict "/workspace/$BUTANE_FILE" > "$BASE_DIR/$IGN_FILE"

if [ $? -ne 0 ]; then
  echo "Error: Butane transformation failed."
  exit 1
fi

echo "Ignition file created: $IGN_FILE"

# Replace boolean with unquoted placeholders using jq and sed
echo "Transforming $(basename $IGN_FILE) to Packer template: $(basename $TEMPLATE_FILE)..."
jq '(.passwd.users[] | select(.name == "${build_username}") | .system) |= "${build_system_user}"' "$BASE_DIR/$IGN_FILE" \
| sed -E 's/("system":\s+)"(\$\{build_system_user\})"/\1\2/' > "$BASE_DIR/$TEMPLATE_FILE"

if [ $? -ne 0 ]; then
  echo "Error: jq transformation failed."
  exit 1
fi

echo "Packer template created: $TEMPLATE_FILE"
exit 0