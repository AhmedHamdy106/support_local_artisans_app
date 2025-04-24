class BasketItem {
  final int? id;  // تعديل هنا ليكون int بدلاً من String
  final String? name;
  final String? pictureUrl;
  final String? brand;
  final String? type;
  final double? price;
    int? quantity;

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
      id: json['id'] as int?,  // تعديل هنا لاستقبال int
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
      'id': id,  // تعديل هنا ليكون int
      'name': name,
      'pictureUrl': pictureUrl,
      'brand': brand,
      'type': type,
      'price': price,
      'quantity': quantity,
    };
  }
}
