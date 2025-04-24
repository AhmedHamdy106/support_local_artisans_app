class Artisan {
  final String id;
  final String displayName;
  final String email;
  final String phoneNumber;

  Artisan({
    required this.id,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
  });

  factory Artisan.fromJson(Map<String, dynamic> json) {
    return Artisan(
      id: json['id'],
      displayName: json['displayName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

class GetMyProductModel {
  final int id;
  final String name;
  final String description;
  final String pictureUrl;
  final double price;
  final int brandId;
  final String brand;
  final int typeId;
  final String type;
  final Artisan artisan;

  GetMyProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureUrl,
    required this.price,
    required this.brandId,
    required this.brand,
    required this.typeId,
    required this.type,
    required this.artisan,
  });

  factory GetMyProductModel.fromJson(Map<String, dynamic> json) {
    return GetMyProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureUrl: json['pictureUrl'],
      price: json['price'],
      brandId: json['brandId'],
      brand: json['brand'],
      typeId: json['typeId'],
      type: json['type'],
      artisan: Artisan.fromJson(json['artisan']),
    );
  }
}
