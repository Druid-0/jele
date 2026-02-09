class Validators {
  static String? validateEmail(String value) {
    if (value.trim().isEmpty) {
      return 'Введите email';
    }
    final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Некорректный email';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.trim().isEmpty) {
      return 'Введите пароль';
    }
    if (value.trim().length < 6) {
      return 'Минимум 6 символов';
    }
    return null;
  }
}
