#!/bin/bash
# lpass-add - non-official SSH key management wrapper for 'lpass' CLI

# Copyright (c) 2016 Luke Turner
# Released under MIT License (SPDX:MIT)

set -o errexit
set -o nounset
set -o pipefail

readonly KEY_NAME="${1:?Usage: lpass-add [lpass-key-id]}"

TEMP_CERT_FILE=$(mktemp)
readonly TEMP_CERT_FILE

onexit() {
	local EXIT_CODE=$?
	echo "Removing temporary file $TEMP_CERT_FILE"
	rm "$TEMP_CERT_FILE"
    if [[ $EXIT_CODE == 0 ]]; then
        echo "lpass-add: identity added successfully"
	else
        echo "lpass-add: failed to add identity $KEY_NAME"
        echo "Script exited with code $EXIT_CODE"
    fi
}

trap onexit EXIT

echo "Writing key $KEY_NAME to temporary file $TEMP_CERT_FILE"
lpass show show --field="Private Key" "$KEY_NAME" > "$TEMP_CERT_FILE"
echo "Adding SSH key $KEY_NAME"
ssh-add "$TEMP_CERT_FILE"