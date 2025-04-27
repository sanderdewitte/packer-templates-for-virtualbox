#!/usr/bin/env bash

# Define paths
BASE_DIR=$(dirname "$0")
COREOS_DATA_PATH="builds/linux/fedora/coreos/data"

# Check if data path exists
if [ ! -d "$COREOS_DATA_PATH" ]; then
  echo "Error: CoreOS data path does not exist: $COREOS_DATA_PATH" >&2
  exit 1
fi

# Define default filenames (overridable by environment variables) 
BUTANE_FILENAME="${BUTANE_FILENAME:-config.bu}"
IGN_FILENAME="${IGN_FILENAME:-config.ign}"
TEMPLATE_FILENAME="${TEMPLATE_FILENAME:-config.ign.pkrtpl.hcl}"

# Define full file paths
BUTANE_FILE="${COREOS_DATA_PATH}/${BUTANE_FILENAME}"
IGN_FILE="${COREOS_DATA_PATH}/${IGN_FILENAME}"
TEMPLATE_FILE="${COREOS_DATA_PATH}/${TEMPLATE_FILENAME}"

# Ensure Butane file exists
if [ ! -f "$BASE_DIR/$BUTANE_FILE" ]; then
  echo "Error: Butane source file ($(basename $BUTANE_FILE)) not found." >&2
  exit 1
fi

# Define whether to overwrite existing Ignition file (default is 'true')
: "${OVERWRITE:=true}"
if [ "$OVERWRITE" != true ] && [ "$OVERWRITE" != false ]; then
  echo "Error: Invalid OVERWRITE value '$OVERWRITE'. Expected 'true' or 'false', case-sensitive." >&2
  exit 1
fi

# Transform Butane to Ignition using Butane Docker image
if [ ! -f "$BASE_DIR/$IGN_FILE" ] || [ "$OVERWRITE" = true ]; then
  echo "Converting $(basename $BUTANE_FILE) to $(basename $IGN_FILE) using Butane..."
  docker run --rm -i \
    -v "$BASE_DIR:/workspace" \
    quay.io/coreos/butane:release \
    --pretty --strict "/workspace/$BUTANE_FILE" > "$BASE_DIR/$IGN_FILE"
  if [ $? -ne 0 ]; then
    echo "Error: Butane transformation failed." >&2
    exit 1
  fi
  echo "Ignition file created: $IGN_FILE"
else
  echo "Warning: Skipping Butane transformation into $IGN_FILE (destination exists and OVERWRITE=false)." >&2
fi

# Replace boolean with unquoted placeholders using jq and sed
if [ -f "$BASE_DIR/$IGN_FILE" ]; then
  echo "Transforming $(basename $IGN_FILE) to Packer template: $(basename $TEMPLATE_FILE)..."
  jq '(.passwd.users[] | select(.name == "${build_username}") | .system) |= "${build_system_user}"' "$BASE_DIR/$IGN_FILE" \
  | sed -E 's/("system":\s+)"(\$\{build_system_user\})"/\1\2/' > "$BASE_DIR/$TEMPLATE_FILE"
  if [ $? -ne 0 ]; then
    echo "Error: jq transformation failed."
    exit 1
  fi
  echo "Packer template created: $TEMPLATE_FILE"
else
  echo "Error: Packer template not created, because Ignition source file ($IGN_FILE) does not exist." >&2
  exit 1
fi

# Exit gracefully
exit 0