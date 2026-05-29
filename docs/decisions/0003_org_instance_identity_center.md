# ADR 0003: Accept the organization instance of IAM Identity Center

## Status
Accepted, May 2026

## Context
When clicking Enable in IAM Identity Center, AWS created an organization instance (instance ID 659558d6623aba36). This implicitly enabled AWS Organizations on the account. The original plan was a single-account landing zone, which only required an account instance.

## Decision
Keep the organization instance. Same Terraform resources work for both instance types. The org instance positions the account for future multi-account expansion without requiring a migration later.

## Alternatives considered
1. Delete and re-create as account instance: not worth the rework, the org instance does not impose additional cost.
2. Move to full AWS Organizations setup with management/log/audit accounts: out of scope for a one-day build, but documented as a roadmap item.

## Consequences
1. AWS Organizations is now active. SCPs become available as a future hardening option.
2. CloudTrail (Phase 5) can be configured as an organization trail rather than account trail.
3. README must clarify that this is a single-account setup deployed inside an org instance, not a full multi-account org.
