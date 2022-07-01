class Validation {

  static bool _isNullOrEmpty(String? s) {
    return s == null || s.isEmpty;
  }

  static bool _hasAlphabetCharacters(String s) {
    return s.contains(RegExp(r'[A-Z]',caseSensitive: false));
  }

  static bool _hasSpecialCharacters(String s) {
    return s.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  static bool _hasWhitespaceCase(String s) {
    return s.contains(" ");
  }

  static bool _hasLowerCase(String s) {
    return s.contains(RegExp(r'[a-z]',caseSensitive: true));
  }

  static bool _hasUpperCase(String s) {
    return s.contains(RegExp(r'[A-Z]',caseSensitive: true));
  }

  static bool _isOfLength(String s, int min, int max) {
    return s.length >= min && s.length <= max;
  }

  static bool _hasDigit(String s) {
    for (int i = 0; i < s.length - 1; i++) {
      if (isNumeric(s[i])) {
        return true;
      }
    }
    return false;
  }

  static isNumeric(string) => num.tryParse(string) != null;

}