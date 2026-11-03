---
description: Milestone 1 - build the Flutter foundation, theme, and component library from Figma
---

1. Read `docs/PRD.md` (sections 3, 7, 8, 9) and `AGENTS.md`.
2. Using the figma MCP server, read the Figma file's Styles/Variables and the `Components` page. Record exact colors, gradients, text styles, spacing, radii, and shadows.
3. Create the Flutter project foundation if missing: feature-first folders, Riverpod, go_router, flutter_lints, Plus Jakarta Sans as an asset, GitHub Actions workflow running `flutter analyze` and `flutter test`.
4. Create `lib/core/theme`: `AppColors`, `AppGradients`, `AppSpacing`, `AppRadius`, `TextTheme`, ThemeExtensions for tints and `shadow.soft`. Values must come from Figma, not guesses.
5. Create `lib/core/utils/format_rupiah.dart` with unit tests for 0, 999, 1000, 7000, 25000, 1250000 in both modes.
6. Implement every component in PRD section 3.2 as a widget in `lib/core/widgets/` with all listed variants and states. No business logic inside.
7. Create a debug-only Component Gallery screen showing every component and variant.
8. Write golden tests for key variants, and widget tests for OtpField (typing, backspace, paste of 6 digits, error state), PhoneField validation, and AppButton loading (ignores taps).
9. Run `flutter analyze` and `flutter test` (prefer the dart MCP server). Fix everything until both are clean.
10. Stop. Report files changed, commands to run, test results, and what I should compare against Figma by eye. Do not start milestone 2.
