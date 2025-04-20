class LoginResponseEntity {
  String? message;
  String? statusMsg;
  LoginUserEntity? user;
  String? token;

  LoginResponseEntity({
    this.message,
    this.statusMsg,
    this.user,
    this.token,
  });
}

class LoginUserEntity {
  String? displayName;
  String? email;
  String? role;

  LoginUserEntity({
    this.displayName,
    this.email,
    this.role,
  });
}
