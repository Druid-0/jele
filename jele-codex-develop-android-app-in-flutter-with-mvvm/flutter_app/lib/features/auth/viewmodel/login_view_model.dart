import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../shared/providers.dart';

class LoginState {
  final Result<User?> result;

  const LoginState(this.result);

  const LoginState.loading() : result = const Result.loading();
}

class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel(this._authRepository) : super(const LoginState(Result.success(null)));

  final AuthRepository _authRepository;

  Future<User?> login(String email, String password) async {
    state = const LoginState.loading();
    try {
      final user = await _authRepository.login(email, password);
      state = LoginState(Result.success(user));
      return user;
    } catch (e) {
      state = LoginState(Result.error(e.toString().replaceFirst('Exception: ', '')));
      return null;
    }
  }
}

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel(ref.read(authRepositoryProvider));
});
