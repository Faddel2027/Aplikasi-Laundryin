---
description: Run analysis and tests and report results honestly
---

1. Run `flutter pub get`.
2. Run `flutter analyze`. It must report zero issues.
3. Run `flutter test`. All tests must pass. If golden tests changed intentionally, say so before updating them with `flutter test --update-goldens`.
4. Check that no hardcoded colors, font sizes, or spacing exist outside `lib/core/theme` (search for `Color(0x`, `fontSize:`, and raw `EdgeInsets` numbers in widgets and screens).
5. Check that every screen changed in this task has loading, empty, error, and offline states.
6. Report: what passed, what failed, what you could not run, and why. Never claim a check passed if you did not run it.
