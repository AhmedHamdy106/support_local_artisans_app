class CurrentUserModel {
  String? email;
  String? displayName;
  String? token;
  String? phoneNumber;
  String? role;

  CurrentUserModel(
      {this.email, this.displayName, this.token, this.phoneNumber, this.role});

  CurrentUserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    displayName = json['displayName'];
    token = json['token'];
    phoneNumber = json['phoneNumber'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['displayName'] = this.displayName;
    data['token'] = this.token;
    data['phoneNumber'] = this.phoneNumber;
    data['role'] = this.role;
    return data;
  }
}
