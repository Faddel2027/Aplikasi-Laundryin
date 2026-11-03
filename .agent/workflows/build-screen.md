---
description: Build one screen from a Figma frame using only existing core widgets
---

I will give you a Figma frame link and a screen name in my message. Then:

1. Read `docs/PRD.md` for the screen's behavior (section 4) and requirement IDs.
2. Using the figma MCP server, fetch the design context and a screenshot of the frame. Identify which existing `core/widgets` it uses.
3. If a needed component does not exist, stop and tell me instead of building ad-hoc UI.
4. Build the screen under `lib/features/<feature>/presentation/` with Riverpod providers, going through a repository interface (fake implementation first).
5. Implement all required states: loading skeleton, empty, error with "Coba Lagi", offline, plus screen-specific states from the PRD.
6. Wire navigation in go_router, including role guards where relevant.
7. Write widget tests for loading / success / error, and extend the integration test if the screen is part of a main flow.
8. Compare the result with the Figma screenshot (spacing, colors, typography) and list any differences honestly.
9. Run `/verify`. Report results and a manual test checklist. Stop.
