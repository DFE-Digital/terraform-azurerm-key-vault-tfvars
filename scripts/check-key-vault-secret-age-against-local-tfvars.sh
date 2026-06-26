#!/bin/bash

# exit on failures
set -e
set -o pipefail

usage() {
  echo "Usage: $(basename "$0") [OPTIONS]" 1>&2
  echo "  -h                        - help"
  echo "  -v <vault_name>           - Azure Key Vault name"
  echo "  -s <secret_name>          - Azure Key Vault Secret name"
  echo "  -f <local_tfars_filename> - Local tfvars file name"
  exit 1
}

# if there are not arguments passed exit with usage
if [ $# -eq 0 ]
then
  usage
fi

while getopts "v:s:f:h" opt; do
  case $opt in
    v)
      VAULT_NAME=$OPTARG
      ;;
    s)
      SECRET_NAME=$OPTARG
      ;;
    f)
      LOCAL_TFVARS_FILE_NAME=$OPTARG
      ;;
    h)
      usage
      ;;
    *)
      usage
      ;;
  esac
done

if [[
  -z "$VAULT_NAME" ||
  -z "$SECRET_NAME" ||
  -z "$LOCAL_TFVARS_FILE_NAME"
]]
then
  usage
fi

set +e
KEY_VAULT_CHECK=$(az keyvault secret list --vault-name "$VAULT_NAME" 2>&1)
set -e

if ! jq -r >/dev/null 2>&1 <<< "$KEY_VAULT_CHECK"
then
  exit 0
fi

SECRET_UPDATED=$(jq -r \
  --arg secret_name "$SECRET_NAME" \
  '.[] | select(.name==$secret_name) | .attributes.updated' \
  <<< "$KEY_VAULT_CHECK")

if [ -z "$SECRET_UPDATED" ]
then
  exit 0
fi

SECRET_UPDATED=$(echo "$SECRET_UPDATED" | cut -d'+' -f1)

if date --version >/dev/null 2>&1; then
  # GNU
  SECRET_UPDATED_SECONDS=$(date -d "$SECRET_UPDATED" "+%s")
else
  # Unix
  SECRET_UPDATED_SECONDS=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$SECRET_UPDATED" "+%s")
fi

if [ "$SECRET_UPDATED_SECONDS" -gt "$(date -r "$LOCAL_TFVARS_FILE_NAME" +%s)" ]
then
  echo ""
  echo ""
  echo "Error: Your local tfvars file is older than the remote!"
  echo ""
  echo "Ensure you have the latest tfvars by running:"
  echo ""
  echo "  mv $LOCAL_TFVARS_FILE_NAME $LOCAL_TFVARS_FILE_NAME.old"
  echo "  az keyvault secret download \\"
  echo "    --file $LOCAL_TFVARS_FILE_NAME \\"
  echo "    --encoding base64 \\"
  echo "    --vault-name $VAULT_NAME \\"
  echo "    --name $SECRET_NAME"
  echo ""
  echo "Or if you are sure your local tfvars are correct, just update the modified time by running:"
  echo ""
  echo "  touch $LOCAL_TFVARS_FILE_NAME"
  echo ""
  exit 1
fi
