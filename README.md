# AWS Secure Baseline with Terraform

Production grade AWS account hardening built entirely as Infrastructure as Code. Deploys from AWS CloudShell with zero local dependencies.

## What this is

A Terraform project that takes a fresh AWS account and turns it into a hardened, audit ready environment in about 3 hours. Seven independent modules cover identity, logging, detection, and network baselines. Every meaningful design decision is documented as an ADR.

I built this to learn AWS Terraform patterns at depth and to have a portfolio piece that demonstrates real cloud security engineering, not just basic IaC.

## What it includes

1. **Bootstrap state backend**: KMS encrypted S3 bucket with versioning, DynamoDB table for state locking, dedicated KMS key with 30 day deletion window
2. **IAM baseline**: strict password policy (14 char min, 90 day rotation, 24 history), break glass admin role with MFA condition and 1 hour session limit
3. **IAM Identity Center**: 5 permission sets (Admin, PowerUser, ReadOnly, Billing, custom DeveloperAccess), 4 RBAC groups, account assignments, explicit denies on dangerous IAM and Organizations actions in DeveloperAccess
4. **Centralized logging**: multi region CloudTrail, KMS encrypted S3 bucket with lifecycle to Glacier at 90 days, CloudWatch Logs integration with 90 day retention
5. **Detection**: GuardDuty with 15 min finding frequency, AWS Config recorder with delivery channel, Security Hub with CIS AWS Foundations Benchmark v1.4 and AWS Foundational Security Best Practices subscribed
6. **Network baseline**: VPC across 3 AZs, public/private/isolated subnets, single NAT Gateway for cost, VPC Flow Logs to CloudWatch, free Gateway VPC Endpoints for S3 and DynamoDB
7. **Documentation**: Architecture Decision Records for every design choice

## Quickstart

Open AWS CloudShell in your target region. Install Terraform:

```bash
TERRAFORM_VERSION="1.15.5"
curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
mkdir -p ~/bin && mv terraform ~/bin/
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
echo 'export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"' >> ~/.bashrc
mkdir -p ~/.terraform.d/plugin-cache
source ~/.bashrc
```

Clone and deploy:

```bash
git clone https://github.com/dev0558/aws-secure-baseline-terraform.git
cd aws-secure-baseline-terraform

# Phase 1: bootstrap state backend
cd bootstrap
terraform init && terraform apply

# Capture outputs and generate backend.hcl
BUCKET=$(terraform output -raw state_bucket_name)
TABLE=$(terraform output -raw lock_table_name)
KMS=$(terraform output -raw kms_key_arn)
REGION=$(terraform output -raw region)
cd ../envs/shared
cat > backend.hcl <<INNER
bucket         = "$BUCKET"
key            = "envs/shared/terraform.tfstate"
region         = "$REGION"
encrypt        = true
kms_key_id     = "$KMS"
dynamodb_table = "$TABLE"
INNER

# Phase 2 to 7: everything else
cp example.tfvars terraform.tfvars
# Edit terraform.tfvars with your IDs (see Manual step below)
terraform init -backend-config=backend.hcl
terraform apply
```

## Manual step

IAM Identity Center has to be enabled in the console once before Terraform can manage permission sets. Open `IAM Identity Center` in the AWS console, click Enable, then retrieve the instance ARN and identity store ID:
Paste both values into `envs/shared/terraform.tfvars`.

## Cost

If left running, roughly 50 USD per month. NAT Gateway dominates:

1. NAT Gateway: ~32 USD/month
2. KMS keys (2): ~2 USD/month
3. GuardDuty: ~5 USD/month (small account)
4. AWS Config: ~5-10 USD/month
5. Security Hub: ~1-3 USD/month
6. CloudTrail, VPC, S3, DynamoDB: pennies

For a portfolio piece, deploy, screenshot, then destroy.

## What broke during the build (real lessons)

1. **Local Mac Command Line Tools too old** for the latest Terraform install. Switched the entire build to AWS CloudShell. CloudShell sidesteps every local dependency problem.
2. **CloudShell ran out of disk space** during the second module init because each module had its own 600 MB copy of the AWS provider. Fixed with `TF_PLUGIN_CACHE_DIR` shared across all modules.
3. **IAM Identity Center created an organization instance** instead of account instance, implicitly enabling AWS Organizations. Kept it because Terraform code works identically for both.
4. **CloudTrail KMS key policy missing** CloudWatch Logs service principal. Added explicit statement for `logs.<region>.amazonaws.com` with the right encryption context condition.
5. **VPC module picked Delhi Local Zone** as the first AZ in Mumbai. NAT Gateway create failed with `NotAvailableInZone`. Fixed by filtering `data.aws_availability_zones` with `opt-in-status = opt-in-not-required`.

## ADRs

All design decisions documented in `docs/decisions/`:

1. ADR 0001: Terraform state in S3 with DynamoDB locking
2. ADR 0002: Use Terraform plugin cache for CloudShell build
3. ADR 0003: Accept the organization instance of IAM Identity Center
4. ADR 0004: Filter Local Zones out of AZ data source

## Destroy
KMS keys enter a 30 day deletion window. Cancel deletion in console if needed.

## Roadmap

1. Migrate to `use_lockfile = true` (S3 native locking, drops the DynamoDB table)
2. Move to multi-account AWS Organizations layout (management + log + audit accounts)
3. Add SCPs for org-wide guardrails
4. WAF and Shield baseline as an 8th module
5. Wire Security Hub findings into Slack or PagerDuty via EventBridge

## License

MIT
