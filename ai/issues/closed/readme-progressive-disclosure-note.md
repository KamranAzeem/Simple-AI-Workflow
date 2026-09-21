Reported: 2026-09-19
Reporter: Kamran Azeem / Kilo (deepseek-flash)
IssueType: Documentation
Severity: P4
Size: S
URL:
Summary: Add a README note on why AGENTS.md is kept short

Description:

Add one sentence to README explaining the progressive-disclosure design behind keeping AGENTS.md short: anything that applies to every session is inline; everything else sits behind a context pointer. It can point to the dictionary's "progressive disclosure" concept for background. No change to AGENTS.md itself.

The user wants to discuss this before deciding its fate, in particular whether it is worth adding and whether it overlaps the dictionary vocabulary ticket.

Origin: `ai/notes/mattpocock-analysis-deferrals-and-readme-note.md` (removed, README item captured here).

---

## 2026-09-22: Implemented on docs/readme-overhaul

- Added one sentence to `README.md` under "How it works": progressive disclosure keeps every-session content inline in `AGENTS.md`, and everything else behind a context pointer.
- No dictionary link. The dictionary vocabulary item is still a separate open ticket, so this note stands alone.
- Awaiting the branch merge before closing.

---

2026-09-22

Closed as part of the `docs/readme-overhaul` squash merge into `master`. The README explains progressive disclosure under "How it works".
