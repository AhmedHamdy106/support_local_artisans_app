import '../../domain/entities/RegisterResponseEntity.dart';

class RegisterResponseDM extends RegisterResponseEntity {
  RegisterResponseDM({super.message, super.statusMsg, super.user, super.token});

  RegisterResponseDM.fromJson(dynamic json) {
    message = json['message']??""; // ✅ تحويل القيمة إلى String
    statusMsg = json[
        'statusMsg']; // ✅ تأكد أن جميع القيم المتوقعة كـ String يتم تحويلها
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }
}

class User extends UserEntity {
  User({super.displayName, super.email, super.role});

  User.fromJson(dynamic json) {
    displayName = json['displayName']?.toString();
    email = json['email']?.toString();
    role = json['role']?.toString();
  }
}
