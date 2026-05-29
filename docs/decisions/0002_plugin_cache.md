# ADR 0002: Use Terraform plugin cache for CloudShell build

## Status
Accepted, May 2026

## Context
CloudShell provides 1 GB of persistent $HOME storage. The AWS provider alone is around 600 MB. With multiple modules (bootstrap, envs/shared, and future module-per-directory layouts), independent .terraform/ directories blow past the disk limit on the second `terraform init`.

## Decision
Set TF_PLUGIN_CACHE_DIR to ~/.terraform.d/plugin-cache in .bashrc. All Terraform commands across all module directories now share one cached copy of each provider.

## Consequences
1. First init in a new module still downloads, but subsequent inits across modules reuse the cache.
2. Cache directory persists across CloudShell sessions.
3. On a workstation with no disk constraints, this is still good practice but less critical.
4. Note: cache reuse is per-version. Upgrading the provider downloads the new version once.
