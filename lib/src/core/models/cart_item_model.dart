import 'menu_item_model.dart';

class CartItemModel {
  final MenuItemModel item;
  int quantity;
  String specialInstructions;

  CartItemModel({
    required this.item,
    this.quantity = 1,
    this.specialInstructions = '',
  });

  double get totalPrice => item.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'menuItemId': item.id,
      'itemName': item.name,
      'unitPrice': item.price,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'specialInstructions': specialInstructions,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      item: MenuItemModel(
        id: map['menuItemId'] ?? '',
        name: map['itemName'] ?? '',
        description: '',
        price: (map['unitPrice'] as num?)?.toDouble() ?? 0.0,
        cuisine: 'Main Dishes',
        allergens: [],
        ingredients: [],
        imageUrl: '',
      ),
      quantity: map['quantity'] ?? 1,
      specialInstructions: map['specialInstructions'] ?? '',
    );
  }
}
