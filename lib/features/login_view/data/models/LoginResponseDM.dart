import '../../domain/entities/LoginResponseEntity.dart';

class LoginResponseDM extends LoginResponseEntity {
  LoginResponseDM({
    super.message,
    super.statusMsg,
    super.user,
    super.token,
    super.userId, // Add userId to the constructor
  });

  LoginResponseDM.fromJson(dynamic json) {
    message = json['message'] as String?;
    statusMsg = json['statusMsg'] as String?;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'] as String?;
    userId = json['userId'] ; // Parse userId from JSON
  }
}class User extends LoginUserEntity {
  User({super.displayName, super.email, super.role});

  User.fromJson(dynamic json) {
    displayName = json['displayName'] as String?;
    email = json['email'] as String?;
    role = json['role'] as String?;
  }
}

// import 'package:support_local_artisans/features/login_view/domain/entities/LoginResponseEntity.dart';
//
// class LoginResponseDM extends LoginResponseEntity {
//   LoginResponseDM({
//     super.message,
//     super.statusMsg,
//     super.user,
//     super.token,
//   });
//
//   LoginResponseDM.fromJson(dynamic json) {
//     message = json['message'];
//     statusMsg = json["statusMsg"];
//     user = json['user'] != null ? LoginUserDM.fromJson(json['user']) : null;
//     token = json['token'];
//   }
// }
//
// class LoginUserDM extends LoginUserEntity {
//   LoginUserDM({
//     super.name,
//     super.email,
//     this.role,
//   });
//
//   LoginUserDM.fromJson(dynamic json) {
//     name = json['name'];
//     email = json['email'];
//     role = json['role'];
//   }
//   String? role;
// }
