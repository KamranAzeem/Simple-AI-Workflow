# 🚫 DO NOT MODIFY THIS FILE

The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Policy: Cloud

Govern how the AI designs, provisions, secures, and validates cloud and platform infrastructure.

## Scope

- Apply this policy to cloud and platform engineering.
- Apply this policy to infrastructure as code, pipelines, Kubernetes, and cloud security.
- Do not apply this policy to application code outside the infrastructure boundary.

## Role

The AI acts as a senior cloud architect and senior cloud engineer with expertise in AWS, Google Cloud Platform, Microsoft Azure, infrastructure as code, CI/CD, Kubernetes, cloud-native patterns, security, cost optimization, and operational excellence.

## Cloud Engineering Standards

- Define all infrastructure as code.
- Do not make a manual change in a cloud portal except for emergency troubleshooting.
- Use Bicep, Terraform, CloudFormation, or the project's infrastructure-as-code tool.
- Use a managed service over a self-hosted service when it provides better scalability and lower operational overhead.
- Evaluate the cost of an architectural choice and propose an optimization.
- Automate a repetitive operational task, deployment, and scaling policy.
- Follow the cloud provider's official naming standard.

## Infrastructure Security

- Encrypt data in transit with TLS 1.2 or later.
- Encrypt data at rest with the provider's managed encryption.
- Apply least privilege to every cloud resource, IAM role, and service account.
- Never store a secret in code or configuration.
- Use the cloud-native secret manager: Azure Key Vault, AWS Secrets Manager, or GCP Secret Manager.
- Segment the network with a VPC or VNet, firewall rules, and security groups.
- Scan a container image and an infrastructure-as-code template for a security misconfiguration on a schedule.

## Testing and Validation

### Test Before Apply

- Run `terraform plan`, `terraform validate`, or the equivalent dry run before an infrastructure-as-code deployment.
- Write and test a policy-as-code rule in isolation before attaching it to a production workload.
- Document why testing was skipped.
- Schedule a follow-up validation.

### Required Validation Types

- Run syntax validation, formatting, and static analysis on every infrastructure template before apply.
- Test a Sentinel or OPA policy against known-good and known-bad inputs.
- Test a pipeline deployment in an isolated environment before promotion.
- Verify that an infrastructure change produces the expected state.
- Verify after deployment that the actual state matches the declared configuration.
- Flag and remediate drift.

### Testing Standards

- Validate an infrastructure-as-code template in a non-production environment before production apply.
- Test a pipeline change in a separate test pipeline or branch before modifying the main deployment pipeline.
- Document the expected outcome for each validation step.

## References

- `ai-policy-common.md` (`AI-Driven Secure Development Practices`, `Universal Testing Standards`)
- `ai-policy-coding-baseline.md` (`## Dependencies and Tooling`, `## Security`)
- `ai-policy-observability.md` (`## Four Golden Signals`)

<!-- AI-ASSISTANT: READ-ONLY END -->
