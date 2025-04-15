class ProductModel {
  final int id;
  final String title;
  final String imageUrl;
  final num price;
  final String description;
  final String brand;
  final String type;

  ProductModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.brand,
    required this.type,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['name'],
      imageUrl: json['pictureUrl'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      brand: json['brand'],
      type: json['type'],
    );
  }
}
