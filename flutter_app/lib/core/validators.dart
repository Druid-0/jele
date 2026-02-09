String? validateEmail(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return 'Введите email';
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(text)) return 'Некорректный email';
  return null;
}

String? validatePassword(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return 'Введите пароль';
  if (text.length < 6) return 'Минимум 6 символов';
  return null;
}
