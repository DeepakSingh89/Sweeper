class Validator {


  static bool isValidEmail(String input) {
    final RegExp regex = new RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return regex.hasMatch(input);
  }


  static bool isValidName(String input) {
    final RegExp regex = new RegExp('[a-zA-Z]');
    return regex.hasMatch(input);
  }

  static bool isValidPassword(String input) {
    final RegExp regExp = new RegExp(
        r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$");
    return regExp.hasMatch(input);
  }

  static bool spaceValidator(String input){
    final RegExp regExp = new RegExp(
        r"^[^\s]+(\s+[^\s]+)*$");
    return regExp.hasMatch(input);
  }


}