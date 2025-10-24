import 'package:flutter/foundation.dart';

class RestaurantModel {
  RestaurantModel({
    required this.id,
    required this.name,
    required this.address,
    required this.isActive,
    required this.approved,
    required this.paymentStatus,
    this.email,
    this.ownerId,
    this.phone,
    this.imageUrl,
    this.imageThumbUrl,
    this.averageDeliveryTime,
    this.createdAt,
    this.updatedAt,
    this.apiIsOpen,
  });

  final String id;
  final String name;
  final String address;
  final bool isActive;
  final bool approved;
  final String paymentStatus;
  final String? email;
  final String? ownerId;
  final String? phone;
  final String? imageUrl;
  final String? imageThumbUrl;
  final int? averageDeliveryTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? apiIsOpen;

  bool get isOpen => apiIsOpen ?? (approved && isActive && paymentStatus.toLowerCase() == 'adimplente');
  bool get canAcceptOrders => isOpen;