import 'package:flutter/material.dart';

import '../../../core/widgets/service_card.dart';
import '../../../core/widgets/status_chip.dart';
import '../domain/order_model.dart';
import '../domain/order_repository.dart';
import '../domain/service_model.dart';

class FakeOrderRepository implements OrderRepository {
  final List<ServiceModel> _services = [
    const ServiceModel(
      id: 'kiloan',
      name: 'Cuci Kiloan',
      categoryLabel: 'LAYANAN KILOAN',
      description: 'Layanan cuci dan setrika pakaian sehari-hari secara higienis, rapi, dan wangi menggunakan deterjen premium ramah lingkungan.',
      startingPrice: 7000,
      unit: 'kg',
      etaText: '2 Hari Kerja',
      minQty: 3,
      badge: 'Paling Populer',
      ratingAvg: 4.9,
      ratingCount: 128,
      benefits: [
        'Deterjen Ramah Lingkungan',
        'Pewangi Premium Tahan Lama',
        'Setrika Uap Rapi Anti Kusut',
        'Garansi Bersih Ulang',
      ],
      note: 'Informasi Penimbangan: Berat akhir akan ditimbang ulang di outlet dan dikonfirmasi langsung lewat aplikasi.',
      icon: Icons.local_laundry_service_rounded,
      colorTheme: ServicePastelColor.blue,
      isActive: true,
    ),
    const ServiceModel(
      id: 'satuan',
      name: 'Cuci Satuan',
      categoryLabel: 'LAYANAN SATUAN',
      description: 'Perawatan khusus untuk pakaian istimewa seperti jas, kemeja batik, gaun, dan kebaya dengan perhatian detail per helai.',
      startingPrice: 15000,
      unit: 'item',
      etaText: '1-2 Hari',
      minQty: 1,
      ratingAvg: 4.8,
      ratingCount: 64,
      benefits: [
        'Pembersihan Manual Teliti',
        'Pelindung Serat Pakaian',
        'Gantungan & Plastik Pelindung',
        'Garansi Kancing & Resleting',
      ],
      note: 'Pakaian dengan payet, bordir, atau bahan sutra mohon dicantumkan pada catatan pesanan.',
      icon: Icons.dry_cleaning_rounded,
      colorTheme: ServicePastelColor.purple,
      isActive: true,
    ),
    const ServiceModel(
      id: 'express',
      name: 'Express Kilat',
      categoryLabel: 'LAYANAN CEPAT',
      description: 'Butuh cucian bersih segera? Layanan express kilat selesai dalam hitungan jam dengan prioritas pengerjaan.',
      startingPrice: 12000,
      unit: 'kg',
      etaText: '6-12 Jam',
      minQty: 3,
      badge: 'Super Cepat',
      ratingAvg: 4.9,
      ratingCount: 92,
      benefits: [
        'Prioritas Mesin Utama',
        'Selesai di Hari yang Sama',
        'Jemput & Antar Ekspres',
        'Kualitas Tetap Terjaga',
      ],
      note: 'Order express sebelum jam 10.00 WIB untuk pengantaran di malam hari.',
      icon: Icons.bolt_rounded,
      colorTheme: ServicePastelColor.amber,
      isActive: true,
    ),
    const ServiceModel(
      id: 'sepatu',
      name: 'Cuci Sepatu',
      categoryLabel: 'LAYANAN SEPATU',
      description: 'Deep cleaning dan unyellowing sepatu sneakers, kanvas, maupun kulit agar kembali bersih dan segar.',
      startingPrice: 25000,
      unit: 'psg',
      etaText: '3 Hari',
      minQty: 1,
      ratingAvg: 4.7,
      ratingCount: 45,
      benefits: [
        'Sabun Khusus Sepatu',
        'Pengering Suhu Rendah',
        'Perlindungan Anti Bakteri',
        'Bonus Silica Gel',
      ],
      note: 'Waktu pengerjaan disesuaikan dengan jenis bahan sepatu.',
      icon: Icons.roller_skating_rounded,
      colorTheme: ServicePastelColor.tosca,
      isActive: true,
    ),
    const ServiceModel(
      id: 'karpet',
      name: 'Cuci Karpet',
      categoryLabel: 'LAYANAN RUMAH',
      description: 'Pencucian karpet rumah dan sajadah dengan vacuum berkekuatan tinggi serta formula penghilang tungau dan bau apek.',
      startingPrice: 35000,
      unit: 'm²',
      etaText: '4 Hari',
      minQty: 1,
      ratingAvg: 4.8,
      ratingCount: 38,
      benefits: [
        'Sedot Debu Mendalam',
        'Pembasmi Kutu & Tungau',
        'Aroma Wangi Tahan Lama',
        'Kemasan Plastik Tebal',
      ],
      note: 'Perhitungan harga berdasarkan luas (panjang x lebar dalam meter persegi).',
      icon: Icons.layers_rounded,
      colorTheme: ServicePastelColor.green,
      isActive: true,
    ),
    const ServiceModel(
      id: 'selimut',
      name: 'Cuci Selimut',
      categoryLabel: 'LAYANAN RUMAH',
      description:
          'Cuci bed cover, selimut bulu, dan sprei ukuran king/queen hingga bersih, harum, dan bebas kuman.',
      startingPrice: 20000,
      unit: 'item',
      etaText: '2 Hari',
      minQty: 1,
      ratingAvg: 4.8,
      ratingCount: 24,
      benefits: [
        'Mesin Kapasitas Besar',
        'Pelembut Ekstra Lembut',
        'Bebas Alergen & Debu',
        'Kemasan Khusus Bedding',
      ],
      note: 'Cuci bed cover, sprei, dan selimut bersih wangi bebas debu & tungau.',
      icon: Icons.bed_rounded,
      colorTheme: ServicePastelColor.rose,
      isActive: true,
    ),
  ];

  // ignore: prefer_final_fields — field is mutated by cancelOrder in M4
  OrderModel? _activeOrder = OrderModel(
    orderId: 'ORD-202610-001',
    serviceId: 'kiloan',
    serviceName: 'Cuci Kiloan (4 kg)',
    status: OrderStatus.dicuci,
    scheduleText: 'Estimasi selesai: Besok, 16.00 WIB',
    estimatedPrice: 28000,
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
  );

  @override
  Future<List<ServiceModel>> getServices() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _services;
  }

  @override
  Future<ServiceModel?> getServiceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _services.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<OrderModel?> getActiveOrder() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _activeOrder;
  }

  @override
  Future<List<OrderModel>> getOrderHistory() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return [
      ?_activeOrder,
      OrderModel(
        orderId: 'ORD-202610-000',
        serviceId: 'satuan',
        serviceName: 'Cuci Satuan (2 item)',
        status: OrderStatus.selesai,
        scheduleText: 'Selesai kemarin',
        estimatedPrice: 30000,
        finalPrice: 30000,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}
