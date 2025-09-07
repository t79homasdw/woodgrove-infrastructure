variable "key_vault_id" {
  type        = string
  description = "ID of the Key Vault where the secret will be stored"
}

variable "secret_name" {
  type        = string
  description = "Name of the secret to rotate"
}

variable "rotation_interval_hours" {
  type        = number
  default     = 720 # 30 days
}

resource "random_password" "rotated_secret" {
  length  = 32
  special = true
}

resource "azurerm_key_vault_secret" "rotated" {
  name         = var.secret_name
  value        = random_password.rotated_secret.result
  key_vault_id = var.key_vault_id
  depends_on   = [random_password.rotated_secret]

  lifecycle {
    ignore_changes = [value] # Prevent unnecessary updates unless triggered
  }
}

resource "time_rotating" "rotation_trigger" {
  rotation_hours = var.rotation_interval_hours
}

resource "null_resource" "rotation" {
  triggers = {
    rotation_time = time_rotating.rotation_trigger.id
  }

  provisioner "local-exec" {
    command = "echo 'Secret rotated at ${time_rotating.rotation_trigger.id}'"
  }

  depends_on = [azurerm_key_vault_secret.rotated]
}