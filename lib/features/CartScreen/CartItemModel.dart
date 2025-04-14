class CartItemModel {
  final int id;
  final String name;
  final String pictureUrl;
  final String brand;
  final String type;
  final int price;
  int quantity;

  CartItemModel({
    required this.id,
    required this.name,
    required this.pictureUrl,
    required this.brand,
    required this.type,
    required this.price,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      pictureUrl: json['pictureUrl'] ?? '',
      brand: json['brand'] ?? '',
      type: json['type'] ?? '',
      price: (json['price'] as num).toInt(), // Ensure price is int
      quantity: (json['quantity'] as num).toInt(), // Ensure quantity is int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "pictureUrl": pictureUrl,
      "brand": brand,
      "type": type,
      "price": price,
      "quantity": quantity,
    };
  }
}
