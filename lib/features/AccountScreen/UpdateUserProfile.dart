class UpdateUserProfile {
  final String statusMsg;
  final String message;
  final User user;

  UpdateUserProfile({
    required this.statusMsg,
    required this.message,
    required this.user,
  });

  factory UpdateUserProfile.fromJson(Map<String, dynamic> json) {
    return UpdateUserProfile(
      statusMsg: json['statusMsg'] as String,
      message: json['message'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusMsg': statusMsg,
      'message': message,
      'user': user.toJson(),
    };
  }
}

class User {
  final String displayName;
  final String email;
  final String phoneNumber;
  final String role;

  User({
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
    };
  }
}
