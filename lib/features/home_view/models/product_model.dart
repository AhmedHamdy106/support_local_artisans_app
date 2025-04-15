class Product {
  final int id;
  final String name;
  final String description;
  final String pictureUrl;
  final double price;
  final int? brandId;
  final String? brand;
  final int? typeId;
  final String? type;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureUrl,
    required this.price,
    this.brandId,
    this.brand,
    this.typeId,
    this.type,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureUrl: json['pictureUrl'],
      price: (json['price'] as num).toDouble(),
      brandId: json['brandId'],
      brand: json['brand'],
      typeId: json['typeId'],
      type: json['type'],
    );
  }
}
