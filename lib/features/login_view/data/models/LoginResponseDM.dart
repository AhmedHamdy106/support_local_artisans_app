import 'package:support_local_artisans/features/login_view/domain/entities/LoginResponseEntity.dart';

class LoginResponseDM extends LoginResponseEntity {
  LoginResponseDM({
    super.message,
    super.statusMsg,
    super.user,
    super.token,
  });

  LoginResponseDM.fromJson(dynamic json) {
    message = json['message'];
    statusMsg = json["statusMsg"];
    user = json['user'] != null ? LoginUserDM.fromJson(json['user']) : null;
    token = json['token'];
  }
}

class LoginUserDM extends LoginUserEntity {
  LoginUserDM({
    super.name,
    super.email,
    this.role,
  });

  LoginUserDM.fromJson(dynamic json) {
    name = json['name'];
    email = json['email'];
    role = json['role'];
  }
  String? role;
}
