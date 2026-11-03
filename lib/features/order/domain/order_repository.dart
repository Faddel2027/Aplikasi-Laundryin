import 'order_model.dart';
import 'service_model.dart';

abstract class OrderRepository {
  Future<List<ServiceModel>> getServices();
  Future<ServiceModel?> getServiceById(String id);
  Future<OrderModel?> getActiveOrder();
  Future<List<OrderModel>> getOrderHistory();
}
