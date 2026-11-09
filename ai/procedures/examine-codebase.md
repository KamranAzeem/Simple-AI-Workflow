# PROCEDURE EXAMINE-CODEBASE: When the user says "examine this codebase" or "codebase examination"

## Triggers

- examine this codebase
- codebase examination

1. **STEP-LOAD-EXAMINATION-POLICY**: Load `ai-policy-codebase-examination.md` from the **Global AI Policies Directory** for the full role definition and four-phase workflow (Map → Plan → Perform → Reconcile).
2. **STEP-RUN-EXAMINATION-WORKFLOW**: Follow the workflow defined in the policy. All Branch-Gating, TDD, and Peer Review guardrails from `ai-policy-common.md` apply.
3. **STEP-EXIT-EXAMINATION**: Return to normal role when the examination session concludes.
