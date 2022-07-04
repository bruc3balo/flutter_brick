class MyValidation {

  static bool isNullOrEmpty(String? s) {
    return s == null || s.isEmpty;
  }

  static bool hasAlphabetCharacters(String s) {
    return s.contains(RegExp(r'[A-Z]',caseSensitive: false));
  }

  static bool hasSpecialCharacters(String s) {
    return s.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  static bool hasWhitespaceCase(String s) {
    return s.contains(" ");
  }

  static bool hasLowerCase(String s) {
    return s.contains(RegExp(r'[a-z]',caseSensitive: true));
  }

  static bool hasUpperCase(String s) {
    return s.contains(RegExp(r'[A-Z]',caseSensitive: true));
  }

  static bool isOfLength(String s, int min, int max) {
    return s.length >= min && s.length <= max;
  }

  static bool hasDigit(String s) {
    for (int i = 0; i < s.length - 1; i++) {
      if (isNumeric(s[i])) {
        return true;
      }
    }
    return false;
  }

  static isNumeric(string) => num.tryParse(string) != null;

}