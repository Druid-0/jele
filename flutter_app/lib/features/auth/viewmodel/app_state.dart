import '../../../domain/entities/user.dart';

enum AppScreen { login, roleSelect, parentApp, teacherApp, studentApp }

class AppState {
  final AppScreen screen;
  final User? user;

  const AppState({
    required this.screen,
    this.user,
  });

  AppState copyWith({
    AppScreen? screen,
    User? user,
  }) {
    return AppState(
      screen: screen ?? this.screen,
      user: user ?? this.user,
    );
  }
}
