import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/user.dart';
import '../../shared/providers.dart';
import 'app_state.dart';

class AppViewModel extends StateNotifier<AppState> {
  AppViewModel() : super(const AppState(screen: AppScreen.login));

  void onLoginSuccess(User user) {
    state = state.copyWith(screen: AppScreen.roleSelect, user: user);
  }

  void selectRole(UserRole role) {
    final user = state.user;
    if (user == null) return;
    final updatedUser = User(id: user.id, email: user.email, role: role, profileId: user.profileId);
    switch (role) {
      case UserRole.parent:
        state = state.copyWith(screen: AppScreen.parentApp, user: updatedUser);
        break;
      case UserRole.teacher:
        state = state.copyWith(screen: AppScreen.teacherApp, user: updatedUser);
        break;
      case UserRole.student:
        state = state.copyWith(screen: AppScreen.studentApp, user: updatedUser);
        break;
    }
  }

  void logout() {
    state = const AppState(screen: AppScreen.login);
  }

  void backToLogin() {
    state = const AppState(screen: AppScreen.login);
  }
}

final appViewModelProvider = StateNotifierProvider<AppViewModel, AppState>(
  (ref) => AppViewModel(),
);
