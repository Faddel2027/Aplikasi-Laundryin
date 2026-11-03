import '../../../core/widgets/status_chip.dart';

class OrderModel {
  final String orderId;
  final String serviceId;
  final String serviceName;
  final OrderStatus status;
  final String scheduleText;
  final int estimatedPrice;
  final int? finalPrice;
  final DateTime createdAt;

  const OrderModel({
    required this.orderId,
    required this.serviceId,
    required this.serviceName,
    required this.status,
    required this.scheduleText,
    required this.estimatedPrice,
    this.finalPrice,
    required this.createdAt,
  });
}
