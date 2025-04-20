class ProductArtistModel {
  int? id;
  String? name;
  String? description;
  String? pictureUrl;
  double? price;
  String? brand;
  String? type;
  String? category;
  Artisan? artisan;

  ProductArtistModel({
    this.id,
    this.name,
    this.description,
    this.pictureUrl,
    this.price,
    this.brand,
    this.type,
    this.category,
    this.artisan,
  });

  factory ProductArtistModel.fromJson(Map<String, dynamic> json) {
    return ProductArtistModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureUrl: json['pictureUrl'],
      price: json['price']?.toDouble(),
      brand: json['brand'],
      type: json['type'],
      category: json['category'],
      artisan: json['artisan'] != null ? Artisan.fromJson(json['artisan']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureUrl': pictureUrl,
      'price': price,
      'brand': brand,
      'type': type,
      'category': category,
      'artisan': artisan?.toJson(),
    };
  }
}

class Artisan {
  String? id;
  String? displayName;
  String? email;
  String? phoneNumber;

  Artisan({
    this.id,
    this.displayName,
    this.email,
    this.phoneNumber,
  });

  factory Artisan.fromJson(Map<String, dynamic> json) {
    return Artisan(
      id: json['id'],
      displayName: json['displayName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}