abstract class Validators {
  static email(String? v) {
    if (v == null || v.isEmpty) {
      return "* Required";
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(v)) {
      return 'Wrong email';
    } else if (v.length > 500) {
      return 'Email should not be greater than 500 characters';
    }
    return null;
  }

  static password(String? v) {
    if (v == null || v.isEmpty) {
      return "* Required";
    } else if (v.length < 6) {
      return "Password should be at least 6 characters";
    } else if (v.length > 15) {
      return "Password should not be greater than 15 characters";
    } else
      return null;
  }

  static name(String? v) {
    if (v == null || v.isEmpty) {
      return "* Required";
    } else if (v.length > 20) {
      return 'Name should not be greater than 20 characters';
    }
    return null;
  }

  static organizationName(String? v) {
    if (v == null || v.isEmpty) {
      return "* Required";
    } else if (v.length > 20) {
      return 'Organization name should not be greater than 20 characters';
    }
    return null;
  }

  static roomName(String? v) {
    if (v == null || v.isEmpty) {
      return "* Required";
    } else if (v.length > 20) {
      return 'Room name should not be greater than 20 characters';
    }
    return null;
  }
}
