class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return 'Email can\'t be empty!';
    }
    return null;
  }
}
