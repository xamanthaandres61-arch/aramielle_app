class MenuItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String cuisine; // Italian, Chinese, Filipino, Steak, Salad, etc.
  final List<String> allergens; // e.g. Peanuts, Dairy, Gluten, Shellfish, Eggs
  final List<String> ingredients;
  final String imageUrl;
  final bool isAvailable;
  final bool isPopular;

  const MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.cuisine,
    required this.allergens,
    required this.ingredients,
    required this.imageUrl,
    this.isAvailable = true,
    this.isPopular = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'cuisine': cuisine,
      'allergens': allergens,
      'ingredients': ingredients,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'isPopular': isPopular,
    };
  }

  factory MenuItemModel.fromMap(Map<String, dynamic> map, String docId) {
    return MenuItemModel(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      cuisine: map['cuisine'] ?? map['cuisineCategory'] ?? 'Main Dishes',
      allergens: List<String>.from(map['allergens'] ?? []),
      ingredients: List<String>.from(map['ingredients'] ?? []),
      imageUrl: map['imageUrl'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      isPopular: map['isPopular'] ?? false,
    );
  }
}
