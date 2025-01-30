import 'package:support_local_artisans/features/register_view/domain/entities/RegisterResponseEntity.dart';

class RegisterResponseDM extends RegisterResponseEntity {
  RegisterResponseDM({
    super.message,
    super.statusMsg,
    super.user,
    super.token,
  });

  RegisterResponseDM.fromJson(dynamic json) {
    message = json['message'];
    statusMsg = json["statusMsg"];
    user = json['user'] != null ? UserDM.fromJson(json['user']) : null;
    token = json['token'];
  }
}

class UserDM extends UserEntity {
  UserDM({
    super.name,
    super.email,
    this.role,
  });

  UserDM.fromJson(dynamic json) {
    name = json['name'];
    email = json['email'];
    role = json['role'];
  }
  String? role;
}
