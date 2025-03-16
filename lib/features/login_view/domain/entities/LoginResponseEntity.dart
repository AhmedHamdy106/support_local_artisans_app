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


// class LoginResponseEntity {
//   LoginResponseEntity({
//     this.message,
//     this.statusMsg,
//     this.user,
//     this.token,
//   });
//
//   String? message;
//   String? statusMsg;
//   LoginUserEntity? user;
//   String? token;
// }
//
// class LoginUserEntity {
//   LoginUserEntity({
//     this.name,
//     this.email,
//   });
//
//   String? name;
//   String? email;
// }
