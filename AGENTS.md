# AGENTS.md — Laundryin (Flutter)

You are a senior Flutter engineer building **Laundryin**, a laundry pickup-and-delivery mobile app.
These rules apply to every task in this repository.

## Sources of truth
1. **Product behavior and data:** `docs/PRD.md` (requirement IDs like `C-03`). Read it before starting any task.
2. **Visual design:** the Figma file linked in `docs/PRD.md` section 3. Read it through the **figma MCP server**
   (`get design context`, variables, styles, screenshots). Never guess colors, sizes, or spacing from memory.
3. If PRD and Figma conflict: Figma wins for appearance, PRD wins for behavior and data. State the conflict in one line.
4. Do not invent features outside the PRD. If something is ambiguous, write your assumption in one line and continue.

## Language
- App UI text: **Indonesian**, informal tone, address the user as "kamu".
- Code, identifiers, comments, commit messages: English.

## Stack (do not swap without asking)
Flutter stable, Dart null safety, Riverpod, go_router (role-based redirect guards), dio,
Firebase (Auth, Firestore, Storage, Cloud Messaging, Crashlytics, Cloud Functions),
google_maps_flutter, geolocator. Payments via Midtrans or Xendit **sandbox** through Cloud Functions only.

## Architecture
- Feature-first: `lib/features/<feature>/{data,domain,presentation}`; shared code in `lib/core/{theme,widgets,utils,router,errors}`.
- Business rules (pricing, order-status transitions, stage mapping) are **pure functions in `domain`**, fully unit-tested.
- UI widgets take plain parameters; no Firebase or business logic inside `core/widgets`.
- Data access through repository interfaces. Start with fake in-memory implementations; add Firebase implementations later.

## Design system rules
- Every reusable UI piece is a widget in `lib/core/widgets/` named exactly as in `docs/PRD.md` section 3.2.
- **Never hardcode** colors, font sizes, spacing, or radii inside widgets or screens. Use `AppColors`, `AppGradients`,
  `AppSpacing`, `AppRadius`, `TextTheme`, and ThemeExtensions.
- Font: Plus Jakarta Sans, bundled as an asset (works offline).
- Money: only through `formatRupiah(int amount, {bool compact = false})` → "Rp7.000" or "Rp7rb".
- Touch targets ≥ 48dp, text must survive 130% system font scale without overflow, WCAG AA contrast,
  wrap every screen body in `SafeArea`.
- Screens are composed only of existing widgets. If a new component is needed, add it to the Component Gallery and tell me.

## Quality rules (the "no bugs" standard)
No software is guaranteed bug-free, so enforce these instead:
- `flutter analyze` must report **zero** issues. `flutter_lints` stays enabled. Never silence a lint without a comment explaining why.
- Every screen implements loading (skeleton), empty, error (with "Coba Lagi"), and offline states.
- Validate inputs in the app and again on the server (Firestore Rules / Cloud Functions).
- Create-order and payment actions are idempotent and safe against double taps and network drops.
- Never lose user input when an action fails.
- Never put secrets or payment server keys in the app. Never commit secrets.

## Testing rules
- Unit tests: pricing, status transitions, stage mapping, `formatRupiah`, validators.
- Widget tests: every P0 screen in loading / success / error states; OtpField and PhoneField behavior.
- Golden tests: key variants of every core widget.
- Integration test: the main order flow, extended each milestone.
- Firestore Security Rules tested with the emulator: cross-role access must be denied.
- A task is **not done** until `flutter analyze` and `flutter test` pass. Run them and report the result honestly.
  If you could not run something, say so; do not claim it passed.

## Working process
1. Read `docs/PRD.md` and the relevant Figma frames first.
2. Work one milestone (PRD section 9) at a time. **Stop at the end of each milestone.**
3. At the end of each milestone report: files created/changed, exact commands to run, results of analyze/test,
   what I should verify manually on a device, and any assumptions or open questions.
4. Prefer small, reviewable changes. Do not refactor unrelated code.

## MCP servers available (see `mcp_config.json`)
- **figma**: read design context, variables, styles, screenshots. Use before building any UI.
- **dart**: analyze, run tests, format, pub operations, widget tree inspection. Prefer it for verification.
- **firebase**: project setup, Firestore rules, and inspecting config. Never deploy to production without asking me.

## Workflows (type `/` in the agent panel)
`/m1-design-system`, `/build-screen`, `/verify`, `/security-rules`.
