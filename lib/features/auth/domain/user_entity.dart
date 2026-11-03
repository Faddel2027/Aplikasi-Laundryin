enum UserRole { customer, courier, cashier, admin }

class UserEntity {
  final String uid;
  final String name;
  final String phoneNumber;
  final UserRole role;
  final String? email;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.phoneNumber,
    this.role = UserRole.customer,
    this.email,
  });

  bool get isCustomer => role == UserRole.customer;
  bool get isCourier => role == UserRole.courier;
  bool get isCashier => role == UserRole.cashier;
  bool get hasProfileCompleted => name.trim().isNotEmpty;

  UserEntity copyWith({
    String? uid,
    String? name,
    String? phoneNumber,
    UserRole? role,
    String? email,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      email: email ?? this.email,
    );
  }
}
