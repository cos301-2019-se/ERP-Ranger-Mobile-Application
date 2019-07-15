
class Validator {

  static String _email = r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$';
  static String _password = r'^(?=.*\d)(?=.*[a-zA-Z]).{8,}$';

  static bool email(String email) {
    if((email != null) && (email.isNotEmpty)) {
      RegExp reg = new RegExp(_email);
      return reg.hasMatch(email);
    }
    return false;
  }

  static bool password(String password) {
    if((password != null) && (password.isNotEmpty)) {
      RegExp reg = new RegExp(_password);
      return reg.hasMatch(password);
    }
    return false;
  }

}