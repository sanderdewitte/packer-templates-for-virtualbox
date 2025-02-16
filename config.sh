#!/usr/bin/env bash

follow_link() {
  local FILE="${1}"
  while [ -L "${FILE}" ]; do
    FILE="$(readlink "${FILE}")"
  done
  echo "${FILE}"
}

cleanup() {
  local EXIT_CODE=$?
  if [ $EXIT_CODE -ne 0 ]; then
    echo "Error: $(basename "$0") exited with status ${EXIT_CODE}."
  fi
}

# Catch errors and run cleanup
trap "cleanup" EXIT

# Define the script and config paths
follow_link_result=$(follow_link "$0")
if ! SCRIPT_PATH=$(realpath "$(dirname "${follow_link_result}")"); then
  echo "Error: follow_link or realpath failed."
  exit 1
fi
CONFIG_PATH=${1:-${SCRIPT_PATH}/config}

# Create directory for HCL variable files
mkdir -p "${CONFIG_PATH}"

# Copy the sample input variables to config directory.
echo
echo "> Copying the sample input variables..."
cp --recursive --no-dereference --preserve=links,timestamps --no-preserve=mode,ownership --verbose "${SCRIPT_PATH}"/builds/*.pkrvars.hcl.sample "${CONFIG_PATH}"
find "${SCRIPT_PATH}"/builds/*/ -type f -name "*.pkrvars.hcl.sample" | while IFS= read -r srcfile; do
  srcdir=$(dirname "${srcfile}" | tr -s /)
  dstfile=$(echo "${srcdir#"${SCRIPT_PATH}"/builds/}" | tr '/' '-')
  cp --recursive --no-dereference --preserve=links,timestamps --no-preserve=mode,ownership --verbose "${srcfile}" "${CONFIG_PATH}/${dstfile}.pkrvars.hcl.sample"
done

# Rename the sample input variables.
echo
echo "> Renaming the sample input variables..."
for file in "${CONFIG_PATH}"/*.pkrvars.hcl.sample; do
  mv -- "${file}" "${file%.sample}"
done

echo
echo "> Done."
