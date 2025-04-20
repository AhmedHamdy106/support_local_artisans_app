class ProductModel {
  int? id;
  String? name;
  String? description;
  String? pictureUrl;
  double? price;
  int? brandId;
  String? brand;
  int? typeId;
  String? type;
  Artisan? artisan;

  ProductModel(
      {this.id,
      this.name,
      this.description,
      this.pictureUrl,
      this.price,
      this.brandId,
      this.brand,
      this.typeId,
      this.type,
      this.artisan});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    pictureUrl = json['pictureUrl'];
    price = json['price'];
    brandId = json['brandId'];
    brand = json['brand'];
    typeId = json['typeId'];
    type = json['type'];
    artisan =
        json['artisan'] != null ? new Artisan.fromJson(json['artisan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['pictureUrl'] = this.pictureUrl;
    data['price'] = this.price;
    data['brandId'] = this.brandId;
    data['brand'] = this.brand;
    data['typeId'] = this.typeId;
    data['type'] = this.type;
    if (this.artisan != null) {
      data['artisan'] = this.artisan!.toJson();
    }
    return data;
  }
}

class Artisan {
  String? id;
  String? displayName;
  String? email;
  String? phoneNumber;

  Artisan({this.id, this.displayName, this.email, this.phoneNumber});

  Artisan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['displayName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['displayName'] = this.displayName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
