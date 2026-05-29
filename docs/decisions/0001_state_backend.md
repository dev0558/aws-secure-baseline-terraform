# ADR 0001: Terraform state in S3 with DynamoDB locking

## Status
Accepted, May 2026

## Context
Need durable, shared, versioned storage for Terraform state, with locking to prevent concurrent runs corrupting state.

## Decision
S3 bucket with versioning and KMS encryption for state storage. DynamoDB table with LockID hash key for state locking.

## Alternatives considered
1. HCP Terraform: third party dependency, free tier has run limits.
2. Local state: not shareable, not safe, no locking.
3. Consul or etcd backend: operational overhead not justified.

## Consequences
1. Bootstrap problem: the S3 bucket and DynamoDB table must exist before any other Terraform config can use them.
2. Solved by a separate bootstrap config using local state, committed to the repo. The bootstrap state contains only resource IDs and names, no secrets.
3. KMS key has a 30 day deletion window for safety against accidental destroy.

## Cost
KMS key 1 USD per month. DynamoDB on demand and S3 storage: pennies at this scale.
