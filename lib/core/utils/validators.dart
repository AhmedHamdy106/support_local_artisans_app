class AppValidators {
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Username is required";
    }
    if (!RegExp(r"^[a-zA-Z][a-zA-Z0-9_]{2,19}$").hasMatch(value)) {
      return "Username must be 3-20 characters long, start with a letter, and contain only letters, numbers, and underscores";
    }
    return null;
  }

  static String? validateEmail(String? val) {
    RegExp emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@(gmail\.com|yahoo\.com|hotmail\.com)$");
    if (val == null || val.trim().isEmpty) {
      return 'Email is required';
    } else if (!emailRegex.hasMatch(val)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Password is required';
    } else if (val.length < 8) {
      return "Password must be at least 8 characters";
    }
    bool hasLowercase = val.contains(RegExp(r'[a-z]'));
    bool hasUppercase = val.contains(RegExp(r'[A-Z]'));
    bool hasNumber = val.contains(RegExp(r'\d'));
    bool hasSpecialChar = val.contains(RegExp(r'[@$!%*?&]'));
    List<String> errors = [];
    if (!hasLowercase) errors.add("at least one lowercase letter");
    if (!hasUppercase) errors.add("at least one uppercase letter");
    if (!hasNumber) errors.add("at least one number");
    if (!hasSpecialChar) {
      errors.add("at least one special character");
    }
    if (errors.isNotEmpty) {
      return "Password must contain ${errors.join(", ")}";
    }

    return null;
  }

  static String? validatePhoneNumber(String? phoneNumber) {
    RegExp egyptPhoneRegex = RegExp(r'^(?:\+20|0)?(10|11|12|15)\d{8}$');
    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      return 'Phone number is required';
    } else if (!egyptPhoneRegex.hasMatch(phoneNumber)) {
      return 'Please enter a valid Egyptian phone number';
    }
    return null;
  }
}
