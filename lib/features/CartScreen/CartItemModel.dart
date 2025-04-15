class CartItemModel {
  String? id;
  List<Items>? items;

  CartItemModel({this.id, this.items});

  CartItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? name;
  String? pictureUrl;
  String? brand;
  String? type;
  int? price;
  int? quantity;

  Items(
      {this.name,
      this.pictureUrl,
      this.brand,
      this.type,
      this.price,
      this.quantity,
      required int id});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    pictureUrl = json['pictureUrl'];
    brand = json['brand'];
    type = json['type'];
    price = json['price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['pictureUrl'] = this.pictureUrl;
    data['brand'] = this.brand;
    data['type'] = this.type;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    return data;
  }
}