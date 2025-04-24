class RegisterResponseEntity {
  String? message;
  String? statusMsg;
  UserEntity? user;
  String? token;

  RegisterResponseEntity({
    this.message,
    this.statusMsg,
    this.user,
    this.token,
  });
}

class UserEntity {
  String? displayName;
  String? email;
  String? role;
  String?phoneNumber;

  UserEntity({
    this.displayName,
    this.email,
    this.role,
    this.phoneNumber
  });
}
