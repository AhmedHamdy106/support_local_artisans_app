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
    RegExp passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    if (val == null || val.trim().isEmpty) {
      return 'Password is required';
    } else if (val.length < 8) {
      return "Password must be at least 8 characters";
    } else if (!passwordRegex.hasMatch(val)) {
      return "Password must be include uppercase,lowercase,number,special character";
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
