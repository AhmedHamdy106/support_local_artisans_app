class LoginResponseEntity {
  LoginResponseEntity({
    this.message,
    this.statusMsg,
    this.user,
    this.token,
  });

  String? message;
  String? statusMsg;
  LoginUserEntity? user;
  String? token;
}

class LoginUserEntity {
  LoginUserEntity({
    this.name,
    this.email,
  });

  String? name;
  String? email;
}
