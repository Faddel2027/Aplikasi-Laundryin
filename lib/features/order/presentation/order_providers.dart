import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/fake_order_repository.dart';
import '../domain/order_model.dart';
import '../domain/order_repository.dart';
import '../domain/service_model.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return FakeOrderRepository();
});

final servicesListProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final repo = ref.watch(orderRepositoryProvider);
  return repo.getServices();
});

class ServiceSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final serviceSearchQueryProvider =
    NotifierProvider<ServiceSearchQueryNotifier, String>(ServiceSearchQueryNotifier.new);

final filteredServicesProvider = Provider<AsyncValue<List<ServiceModel>>>((ref) {
  final servicesAsync = ref.watch(servicesListProvider);
  final query = ref.watch(serviceSearchQueryProvider).trim().toLowerCase();

  return servicesAsync.whenData((services) {
    if (query.isEmpty) return services;
    return services.where((s) {
      return s.name.toLowerCase().contains(query) ||
          s.description.toLowerCase().contains(query) ||
          s.categoryLabel.toLowerCase().contains(query);
    }).toList();
  });
});

final activeOrderProvider = FutureProvider<OrderModel?>((ref) async {
  final repo = ref.watch(orderRepositoryProvider);
  return repo.getActiveOrder();
});

final serviceDetailProvider = FutureProvider.family<ServiceModel?, String>((ref, id) async {
  final repo = ref.watch(orderRepositoryProvider);
  return repo.getServiceById(id);
});
