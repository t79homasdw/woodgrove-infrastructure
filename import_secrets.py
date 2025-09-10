import subprocess

# List of secrets to import
secrets_to_import = [
    {
        "vault_name": "kv-3cloud-dev-demo",
        "secret_name": "backup-sas-token",
        "version": "70420b1f73864833afbe49415598fdb5"
    },
    # Add more secrets here
    # {"vault_name": "your-vault", "secret_name": "your-secret", "version": "optional-version"},
]

# Terraform resource address
resource_address = "module.sas_token_rotation.azurerm_key_vault_secret.rotated"

for secret in secrets_to_import:
    vault = secret["vault_name"]
    name = secret["secret_name"]
    version = secret.get("version")

    # Construct import ID
    import_id = f"{vault}/{name}/{version}" if version else f"{vault}/{name}"

    # Build and run the terraform import command
    command = ["terraform", "import", resource_address, import_id]
    print(f"Running: {' '.join(command)}")
    subprocess.run(command)
