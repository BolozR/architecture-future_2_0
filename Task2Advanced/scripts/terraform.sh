#!/bin/sh
set -eu
umask 077
command=${1:-}
environment=${2:-}
case "$command" in init|plan|apply) ;; *) echo "Usage: $0 init|plan|apply dev|stage|prod" >&2; exit 2;; esac
case "$environment" in dev|stage|prod) ;; *) echo "Unknown environment" >&2; exit 2;; esac
: "${TF_STATE_BUCKET:?Set the bucket for this environment}"
: "${AWS_ACCESS_KEY_ID:?Set the Object Storage access key}"
: "${AWS_SECRET_ACCESS_KEY:?Set the Object Storage secret key}"
: "${YC_SERVICE_ACCOUNT_KEY_FILE:?Set the path to the provider service account key file}"
: "${TF_VAR_folder_id:?Set the folder for this environment}"
: "${TF_VAR_subnet_id:?Set the subnet for this environment}"
: "${TF_VAR_image_id:?Set the Linux image ID}"
: "${TF_VAR_ssh_public_key:?Set the public SSH key}"
: "${TF_VAR_ssh_cidrs:?Set the SSH administration CIDRs}"
if [ "$command" = apply ]; then
  if [ "${CI:-}" != true ] || [ "${CI_COMMIT_REF_PROTECTED:-}" != true ]; then
    echo "Apply runs only in the protected manual CI job" >&2
    exit 2
  fi
fi
project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cd "$project_dir/Task2Advanced/envs/$environment"
terraform init -input=false -lockfile=readonly -backend-config=backend.hcl -backend-config="bucket=$TF_STATE_BUCKET"
case "$command" in
  init) ;;
  plan)
    terraform fmt -check
    terraform validate
    terraform plan -input=false -lock-timeout=5m -var-file="$environment.tfvars" -out=deployment.tfplan
    terraform show -no-color deployment.tfplan > deployment.plan.txt
    ;;
  apply)
    test -s deployment.tfplan
    terraform apply -input=false -lock-timeout=5m deployment.tfplan
    ;;
esac
