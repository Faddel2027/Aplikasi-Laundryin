---
description: Write and test Firestore Security Rules for the role matrix
---

1. Read `docs/PRD.md` sections 2, 5, and 8.
2. Write `firestore.rules` enforcing: customers read and write only their own addresses, orders, and reviews; customers may cancel only before status "Dijemput"; couriers read only orders assigned to them and may only perform allowed status transitions with required proof; cashiers read all outlet orders and update processing statuses; nobody except Cloud Functions writes payment status; prices are never writable by customers.
3. Validate field types and allowed status transitions in the rules.
4. Write emulator-based tests (`@firebase/rules-unit-testing`) covering allowed and denied cases for every role.
5. Run the tests with the Firebase emulator. Do not deploy to production; show me the deploy command and wait for my approval.
6. Report allowed/denied matrix results and anything you could not verify.
