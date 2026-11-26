Reported: 2026-11-26
Reporter: Kamran Azeem
IssueType: Documentation
Severity: Human-to-decide (AI estimate: P3)
Size: Human-to-decide (AI estimate: S)
Label:
URL:
Summary: Documented ./support-files commands fail because six scripts are not executable.

Description:

The repository runs `core.fileMode=false` and records executable bits explicitly, per the 2026-11-26 ADR. Six scripts are mode 100644 in git.

- 100644 in git: `support-files/path-probe.sh`, `support-files/index-protocol.sh`, `support-files/audit-slides.sh`, `support-files/build-slide-diagrams.sh`, `support-files/build-slides-html.sh`, `support-files/render-slides-preview.sh`.
- Usage lines that start with `./support-files/...`: `support-files/audit-slides.sh:4`, `support-files/build-slide-diagrams.sh:3`, `support-files/build-slides-html.sh:3`, and `support-files/render-slides-preview.sh:3`.
- `ai/procedures/load-context.md:16` names `support-files/path-probe.sh` with no `bash`.
- `ai/policies/ai-policy-presentation.md:59` names `support-files/build-slide-diagrams.sh` with no `bash`.
- The tests and `ai/knowledge/slide-deck-visual-system.md` use `bash support-files/...`, which works.

Impact: a human or agent that copies the documented form runs `./support-files/path-probe.sh` and gets permission denied. This examination hit that at boot.

Resolution:

- Add the `bash` prefix to the procedure step, the presentation policy line, and the usage lines.
- Or record the executable bits with `git update-index --chmod=+x` for the scripts meant to run directly.

Acceptance criteria:

- Every documented invocation runs as written.
- The executable-script convention is consistent between the docs, the tests, and the git modes.

---
2026-11-26
Filed from the 2026-11-26 codebase examination. Evidence group F4. No secret or identifying name present.

---
2026-11-26
Plan: `ai/plans/docs-batch-f2-to-f5.md` (M), batched with F2 to F5. Plan reviews 195 (CHANGES REQUESTED, fixed) and 196 (APPROVED). No branch; the tickets stay open until the implement request.
