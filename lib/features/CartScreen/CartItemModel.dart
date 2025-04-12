// cart_item_model.dart
class CartItemModel {
  final String name;
  final int price;
  final int quantity;

  CartItemModel({
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      quantity: json['quantity'] ?? 1,
    );
  }
}
