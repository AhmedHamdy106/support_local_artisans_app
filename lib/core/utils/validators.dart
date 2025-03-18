class AppValidators {
  static String? validateEmail(String? val) {
    RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$");
    if (val == null || val.trim().isEmpty) {
      return 'Email is required';
    } else if (!emailRegex.hasMatch(val)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? val) {
    RegExp passwordRegex = RegExp(
        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
    if (val == null || val.trim().isEmpty) {
      return 'Password is required';
    } else if (val.length < 8) {
      return 'Password must be at least 8 characters long';
    } else if (!passwordRegex.hasMatch(val)) {
      return "Password must contain uppercase, lowercase, number, and special character";
    }
    return null;
  }

  static String? validatePhoneNumber(String? phoneNumber) {
    RegExp egyptPhoneRegex = RegExp(r'^(\+20|0)?(10|11|12|15)\d{8}\$');
    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      return 'Phone number is required';
    } else if (!egyptPhoneRegex.hasMatch(phoneNumber)) {
      return 'Please enter a valid Egyptian phone number';
    }
    return null;
  }
}
