class AppValidators {
  static String? validateEmail(String? val) {
    RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$");
    if (val == null) {
      return 'this field is required';
    } else if (val.trim().isEmpty) {
      return 'this field is required';
    } else if (emailRegex.hasMatch(val) == false) {
      return 'please enter valid email';
    } else {
      return null;
    }
  }

  static String? validatePassword(String? val) {
    RegExp passwordRegex = RegExp(
        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
    if (val == null) {
      return 'this field is required';
    } else if (val.isEmpty) {
      return 'this field is required';
    } else if (val.length < 8) {
      return 'strong password please';
    } else if (passwordRegex.hasMatch(val) == false) {
      return "please enter valid password";
    } else {
      return null;
    }
  }

  static bool isValidEgyptianPhoneNumber(String phoneNumber) {
    // تعريف Regex للتحقق من أرقام الهواتف المصرية
    RegExp egyptPhoneRegex = RegExp(r'^(\+20|0)?1[0-9]{9}$');

    // التحقق من الرقم
    return egyptPhoneRegex.hasMatch(phoneNumber);
  }
}
