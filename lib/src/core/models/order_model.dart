import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String tableNumber;
  final String orderType; // 'Dine-in', 'Take-out'
  final List<CartItemModel> items;
  final double subtotal;
  final double discountAmount;
  final double totalAmount;
  final String discountType; // 'None', 'Senior Citizen', 'PWD'
  final String paymentStatus; // 'Pending Verification', 'Paid'
  final String orderStatus; // 'Pending Verification', 'Preparing', 'Ready', 'Served'
  final String paymentReceiptUrl;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.tableNumber,
    required this.orderType,
    required this.items,
    required this.subtotal,
    required this.discountAmount,
    required this.totalAmount,
    required this.discountType,
    required this.paymentStatus,
    required this.orderStatus,
    required this.paymentReceiptUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tableNumber': tableNumber,
      'orderType': orderType,
      'items': items.map((e) => e.toMap()).toList(),
      'subtotal': subtotal,
      'discountAmount': discountAmount,
      'totalAmount': totalAmount,
      'discountType': discountType,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'paymentReceiptUrl': paymentReceiptUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      tableNumber: json['tableNumber'] ?? 'Table 01',
      orderType: json['orderType'] ?? 'Dine-in',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromMap(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      discountType: json['discountType'] ?? 'None',
      paymentStatus: json['paymentStatus'] ?? 'Pending',
      orderStatus: json['orderStatus'] ?? 'Pending',
      paymentReceiptUrl: json['paymentReceiptUrl'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
