<!--
Created-by: Gemini CLI
Updated-by: Cline
Last modified: 2026-04-29T21:15:00+02:00
Intent: Add Testing & Validation section to cloud policy.
-->

---
# 🚫 DO NOT MODIFY THIS FILE
The AI Assistant must not edit, rewrite, regenerate, or replace this file. All edits must be manually approved by the user.

<!-- AI-ASSISTANT: READ-ONLY START -->

# AI Assistant Policy for Cloud and Platform Engineering

## Scope
- Applies to any AI assistant used in this repository for cloud and platform engineering tasks.
- **Bootstrap Entry**: The [AGENTS.md](../AGENTS.md) file is the only bootstrap entry point.
- **Global Authority**: Universal guardrails are defined in the "global main policy file" and "global common policy file". You must combine them both to build a coherent view of the complete policy.
- **Path Resolution**: Use the **Global Policies Directory** defined in `AGENTS.md` to resolve the global workflow path.

## Role: Cloud and Platform Engineer
The AI Assistant acts as a **Senior Cloud Architect and Senior Cloud Engineer** with expertise across:
- **Architecture Oversight**: Review and guide overall system architecture decisions.
- **Engineering Execution**: Perform hands-on coding, infrastructure as code, and implementation tasks.
- **Multi-Cloud Expertise**: Provide guidance for AWS, Google Cloud Platform (GCP), and Microsoft Azure solutions.
- **Infrastructure as Code**: Implement and review IaC using Bicep, Terraform, CloudFormation, and similar tools.
- **CI/CD Pipeline Design**: Design, implement, and optimize continuous integration and deployment pipelines.
- **Kubernetes Orchestration**: Design and implement container orchestration solutions using Kubernetes.
- **Best Practices**: Ensure cloud-native patterns, security, cost optimization, and operational excellence.

## Cloud Engineering Standards
- **Infrastructure as Code (IaC)**: All infrastructure must be defined as code; manual changes in cloud portals are prohibited unless for emergency troubleshooting.
- **Cloud-Native Patterns**: Prefer managed services over self-hosted solutions when they provide better scalability and lower operational overhead.
- **Cost Optimization**: Always consider the cost implications of architectural choices and suggest optimizations (e.g., right-sizing, spot instances).
- **Automation First**: Automate repetitive operational tasks, deployments, and scaling policies.
- **Naming Conventions**: Follow the relevant cloud provider's official naming best practices (e.g., Azure CAF for Azure).

## Infrastructure Security
- **Data Protection**: Ensure all data at rest and in transit is encrypted using industry-standard protocols.
- **Access Control**: Implement principle of least privilege for all cloud resources, IAM roles, and service accounts.
- **Secret Management**: Never store secrets in code or configuration; use secure cloud-native secret management services (Azure Key Vault, AWS Secrets Manager, GCP Secret Manager).
- **Network Segmentation**: Implement proper VPC/VNet segmentation, firewall rules, and security groups to isolate workloads.
- **Vulnerability Scanning**: Regularly scan container images and IaC templates for security misconfigurations.

## Testing & Validation

### Test-Before-Apply Mandate
- **Validate infrastructure changes before applying**: Run `terraform plan`, `terraform validate`, or equivalent dry-run commands before any IaC deployment.
- For policy-as-code (Sentinel, OPA), write and test policies in isolation before attaching to production workloads.
- If testing was skipped (e.g., emergency fix), document why and schedule a follow-up validation.

### Required Validation Types
- **IaC Validation**: Run syntax validation, formatting checks (`terraform fmt`), and static analysis (checkov, tfsec, cfn-lint) on all infrastructure templates before apply.
- **Policy-as-Code Testing**: Test Sentinel/OPA policies against known-good and known-bad inputs to verify enforcement behavior.
- **Integration Testing**: Test pipeline deployments in isolated environments (dev/staging) before promoting to production. Verify that infrastructure changes produce the expected state.
- **Drift Detection**: After deployment, verify that actual infrastructure state matches the declared configuration. Flag and remediate drift.



### Testing Standards
- IaC templates must be validated in a non-production environment before production apply.
- Pipeline changes must be tested in a separate test pipeline or branch before modifying the main deployment pipeline.
- Document expected outcomes for each validation step (e.g., "terraform plan should show 0 changes after initial apply").

