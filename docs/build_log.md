# Build Log: AWS Secure Landing Zone

## Phase 0: Foundations
1. AWS account created, root hardened (MFA on, no access keys)
2. Budgets set: zero spend alert and 20 USD threshold
3. Bootstrap IAM user tf_bootstrap_admin created with MFA
4. CloudShell chosen as build environment (works around local Mac CLT issue)
5. Terraform 1.15.5 installed in CloudShell ~/bin
6. Region: ap-south-1 (Mumbai)

## Phase 1: Bootstrap state backend
1. KMS key alias landing_zone_tfstate, rotation enabled, 30 day deletion window
2. S3 bucket with versioning, SSE-KMS, public access block, lifecycle expiring noncurrent versions at 90 days
3. DynamoDB table landing_zone_tfstate_lock, PAY_PER_REQUEST, point in time recovery on, SSE-KMS
4. Apply result: 9 added, 0 changed, 0 destroyed
5. Naming note: bucket uses hyphens (S3 constraint), other resources use underscores

## Issues hit
(none in Phase 1)

## Decisions
ADR 0001: Terraform state in S3 with DynamoDB locking

## Phase 2: Main module skeleton
1. Created envs/shared/ with partial backend config (backend.hcl gitignored)
2. Plugin cache configured at ~/.terraform.d/plugin-cache to handle CloudShell 1 GB limit (ADR 0002)
3. terraform init successful, state now in S3 with KMS encryption
4. Deprecation warning noted: dynamodb_table -> use_lockfile (future improvement, ADR 0003 pending)

## Phase 3: IAM baseline
1. Strict password policy applied (14 char min, 90 day max age, 24 reuse history, full complexity)
2. break_glass_admin role created with AdministratorAccess, MFA required, 1 hour session max
3. Trust policy restricted to bootstrap user with aws:MultiFactorAuthPresent=true and aws:MultiFactorAuthAge<3600
4. Tested: assume-role without MFA correctly denied, with MFA succeeded
5. Apply result: 3 added, 0 changed, 0 destroyed

## Phase 5: Centralized logging
1. KMS key alias landing_zone_cloudtrail, dedicated to CloudTrail log encryption
2. S3 bucket for CloudTrail logs with versioning, SSE-KMS, public access block, lifecycle to Glacier at 90 days
3. CloudTrail trail landing_zone_trail: multi-region, log file validation, KMS encrypted
4. CloudWatch Log Group /aws/cloudtrail/landing_zone with 90 day retention
5. IAM role for CloudTrail to write to CloudWatch Logs
6. KMS key policy includes service principals for cloudtrail.amazonaws.com and logs.region.amazonaws.com with proper encryption context conditions
7. Apply result: 13 added, 0 changed, 0 destroyed

## Phase 6: Detection
1. GuardDuty detector enabled with 15-minute finding frequency
2. AWS Config recorder + delivery channel + dedicated S3 bucket (AES256)
3. Security Hub enabled with CIS AWS Foundations Benchmark v1.4.0 and AWS Foundational Security Best Practices v1.0.0
4. Apply: 15 added, 0 changed, 0 destroyed

## Phase 7: Network baseline
1. VPC 10.0.0.0/16 across 3 standard AZs (excluded Delhi Local Zone, ADR 0004)
2. 9 subnets total: 3 public, 3 private, 3 isolated/intra
3. Single NAT Gateway in ap-south-1a (cost optimization)
4. VPC Flow Logs to CloudWatch, 90 day retention
5. Gateway VPC Endpoints for S3 and DynamoDB
6. Apply: 20 added, 1 changed, 18 destroyed (NAT failure required AZ recreate)

## Issues hit during build
1. Mac Command Line Tools outdated, switched to CloudShell
2. CloudShell 1 GB disk limit, plugin cache (ADR 0002)
3. Identity Center created organization instance (ADR 0003)
4. NAT Gateway create failed in Delhi Local Zone (ADR 0004)

## Validated tests
1. break_glass_admin AssumeRole without MFA: correctly denied
2. CloudTrail actively logging
3. NAT Gateway public IP: 13.207.177.174

## Final: ~95 resources across 7 modules


## Phase 6: Detection
1. GuardDuty detector enabled with 15-minute finding frequency
2. AWS Config recorder + delivery channel + dedicated S3 bucket (AES256)
3. Security Hub with CIS AWS Foundations Benchmark v1.4.0 and AWS Foundational Security Best Practices v1.0.0
4. Apply: 15 added, 0 changed, 0 destroyed

## Phase 7: Network baseline
1. VPC 10.0.0.0/16 across 3 standard AZs (excluded Delhi Local Zone, ADR 0004)
2. 9 subnets total: 3 public, 3 private, 3 isolated/intra
3. Single NAT Gateway in ap-south-1a (cost optimization)
4. VPC Flow Logs to CloudWatch, 90 day retention
5. Gateway VPC Endpoints for S3 and DynamoDB
6. Apply: 20 added, 1 changed, 18 destroyed (NAT failure required AZ recreate)

## Issues hit during build
1. Mac Command Line Tools outdated, switched to CloudShell
2. CloudShell 1 GB disk limit, plugin cache (ADR 0002)
3. Identity Center created organization instance (ADR 0003)
4. NAT Gateway create failed in Delhi Local Zone (ADR 0004)

## Validated tests
1. break_glass_admin AssumeRole without MFA: correctly denied
2. CloudTrail actively logging
3. NAT Gateway public IP: 13.207.177.174

## Final: ~95 resources across 7 modules
