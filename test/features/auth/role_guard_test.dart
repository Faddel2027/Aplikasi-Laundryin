import 'package:flutter_test/flutter_test.dart';
import 'package:laundryin/core/router/app_router.dart';
import 'package:laundryin/features/auth/domain/user_entity.dart';
import 'package:laundryin/features/auth/data/fake_auth_repository.dart';

void main() {
  group('Milestone 3: Role-based Redirection Guard Tests (Gate M3)', () {
    test('Unauthenticated user cannot access protected portals and is redirected to /login', () {
      expect(
        roleBasedRedirectGuard(user: null, currentPath: '/courier'),
        equals('/login'),
      );
      expect(
        roleBasedRedirectGuard(user: null, currentPath: '/cashier'),
        equals('/login'),
      );
      expect(
        roleBasedRedirectGuard(user: null, currentPath: '/complete-profile'),
        equals('/login'),
      );
      expect(
        roleBasedRedirectGuard(user: null, currentPath: '/home'),
        isNull,
      );
      expect(
        roleBasedRedirectGuard(user: null, currentPath: '/login'),
        isNull,
      );
    });

    test('Customer role is strictly denied from accessing /courier or /cashier', () {
      const customer = UserEntity(
        uid: 'cust-001',
        name: 'Barup',
        phoneNumber: '+6281234567890',
        role: UserRole.customer,
      );

      // Accessing courier portal should be redirected back to /home
      expect(
        roleBasedRedirectGuard(user: customer, currentPath: '/courier'),
        equals('/home'),
      );

      // Accessing cashier portal should be redirected back to /home
      expect(
        roleBasedRedirectGuard(user: customer, currentPath: '/cashier'),
        equals('/home'),
      );

      // Accessing home portal is permitted
      expect(
        roleBasedRedirectGuard(user: customer, currentPath: '/home'),
        isNull,
      );
    });

    test('Courier role is strictly denied from accessing /home or /cashier', () {
      const courier = UserEntity(
        uid: 'kurir-001',
        name: 'Bambang',
        phoneNumber: '+628111222333',
        role: UserRole.courier,
      );

      // Accessing customer home should be redirected back to /courier
      expect(
        roleBasedRedirectGuard(user: courier, currentPath: '/home'),
        equals('/courier'),
      );

      // Accessing cashier portal should be redirected back to /courier
      expect(
        roleBasedRedirectGuard(user: courier, currentPath: '/cashier'),
        equals('/courier'),
      );

      // Accessing courier portal is permitted
      expect(
        roleBasedRedirectGuard(user: courier, currentPath: '/courier'),
        isNull,
      );
    });

    test('Cashier role is strictly denied from accessing /home or /courier', () {
      const cashier = UserEntity(
        uid: 'kasir-001',
        name: 'Dewi',
        phoneNumber: '+628333444555',
        role: UserRole.cashier,
      );

      // Accessing customer home should be redirected back to /cashier
      expect(
        roleBasedRedirectGuard(user: cashier, currentPath: '/home'),
        equals('/cashier'),
      );

      // Accessing courier portal should be redirected back to /cashier
      expect(
        roleBasedRedirectGuard(user: cashier, currentPath: '/courier'),
        equals('/cashier'),
      );

      // Accessing cashier portal is permitted
      expect(
        roleBasedRedirectGuard(user: cashier, currentPath: '/cashier'),
        isNull,
      );
    });

    test('Role switching in repository updates user role correctly', () async {
      final repo = FakeAuthRepository();
      final customerUser = await repo.verifyOtp('+6281234567890', '123456');
      expect(customerUser.role, equals(UserRole.customer));

      final courierUser = await repo.switchRole(UserRole.courier);
      expect(courierUser.role, equals(UserRole.courier));

      final cashierUser = await repo.switchRole(UserRole.cashier);
      expect(cashierUser.role, equals(UserRole.cashier));

      final backToCust = await repo.switchRole(UserRole.customer);
      expect(backToCust.role, equals(UserRole.customer));
    });

    test('signInAsRole directly logs in user with desired role and attributes', () async {
      final repo = FakeAuthRepository();
      final cust = await repo.signInAsRole(UserRole.customer);
      expect(cust.role, equals(UserRole.customer));
      expect(cust.name, equals('Barup'));

      final cour = await repo.signInAsRole(UserRole.courier);
      expect(cour.role, equals(UserRole.courier));
      expect(cour.name, contains('Kurir'));

      final cash = await repo.signInAsRole(UserRole.cashier);
      expect(cash.role, equals(UserRole.cashier));
      expect(cash.name, contains('Kasir'));
    });
  });
}
