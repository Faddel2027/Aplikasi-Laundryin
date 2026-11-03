import 'package:flutter/material.dart';

import '../../../core/widgets/service_card.dart';

class ServiceModel {
  final String id;
  final String name;
  final String categoryLabel;
  final String description;
  final int startingPrice;
  final String unit;
  final String etaText;
  final int minQty;
  final String? badge;
  final double ratingAvg;
  final int ratingCount;
  final List<String> benefits;
  final String note;
  final IconData icon;
  final ServicePastelColor colorTheme;
  final bool isActive;
  final String? imageUrl;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.categoryLabel,
    required this.description,
    required this.startingPrice,
    required this.unit,
    required this.etaText,
    required this.minQty,
    this.badge,
    this.ratingAvg = 0.0,
    this.ratingCount = 0,
    required this.benefits,
    required this.note,
    required this.icon,
    required this.colorTheme,
    this.isActive = true,
    this.imageUrl,
  });
}
