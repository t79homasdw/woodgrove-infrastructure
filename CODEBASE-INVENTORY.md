
# Woodgrove Infrastructure — Codebase Inventory

> File-by-file description of what each component does, how it is wired, and how to operate it.
>
> **Status:** Placeholder generated before accessing the repository files. Once code is shared, I will replace this with a complete, accurate inventory.

## How to read this document
- **Path** — filesystem path from repo root
- **Type** — module/script/template/pipeline/doc
- **Purpose** — what it does at a high level
- **Key Inputs / Outputs** — important variables/parameters and artifacts
- **Operational Notes** — runbooks, dependencies, and gotchas

## Repository Overview (to be updated)
```
<repo tree goes here>
```

## Detailed Inventory (examples; to be replaced with actual)

### /platform/
- **main.tf** (Terraform module entry) — provisions core landing zone: RGs, log analytics, policy assignments. Inputs: subscription_id, location, tags. Outputs: rg_ids, law_id. Operational: run once per subscription; immutable resource names.
- **variables.tf** — inputs contract and validation.
- **outputs.tf** — outputs exported to higher-level stacks.

### /modules/network/
- **vnet.tf** — creates VNet, subnets (app, data, management), and NSGs.
- **firewall.tf** — optional Azure Firewall; route tables to force egress through hub.
- **privatedns.tf** — private DNS zones and links.

### /environments/dev/**
- **dev.tfvars** — environment-specific settings (names, CIDRs, SKUs).
- **backend.tf** — remote state config (e.g., azurerm backend in a storage account).

### /pipelines/**
- **plan.yml** — PR validation and plan.
- **apply.yml** — gated apply on merge with approvals.

> These are illustrative entries. I will replace this section with the **actual** file list and descriptions after I can read the repository.

## Open Questions (to finalize docs)
- Terraform or Bicep (or mixed)?
- CI system (GitHub Actions vs Azure DevOps) and environments naming?
- Centralized hub-spoke networking or per-app VNets?
- State storage (Terraform) and secrets management (Key Vault references)?

## Appendix — Automated Inventory Script
To regenerate this file automatically from a working copy:

```bash
python tools/generate_inventory.py > docs/CODEBASE-INVENTORY.md
```

Where `generate_inventory.py` walks the repo, captures top-of-file comments and emits a Markdown table with purpose and inputs/outputs. I can supply this script on request or include it in `tools/`.
