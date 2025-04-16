class BasketItem {

  final String? id;
  final String? name;
  final String? pictureUrl;
  final String? brand;
  final String? type;
  final double? price;
  late final int? quantity;

  BasketItem({
    required this.id,
    required this.name,
    required this.pictureUrl,
    required this.brand,
    required this.type,
    required this.price,
    required this.quantity,
  });

  factory BasketItem.fromJson(Map<String, dynamic> json) {
    return BasketItem(
      id: json['id'] as String?,
      name: json['name'] as String?,
      pictureUrl: json['pictureUrl'] as String?,
      brand: json['brand'] as String?,
      type: json['type'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      quantity: json['quantity'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pictureUrl': pictureUrl,
      'brand': brand,
      'type': type,
      'price': price,
      'quantity': quantity,
    };
  }
}