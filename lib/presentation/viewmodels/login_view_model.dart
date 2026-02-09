import 'package:flutter/foundation.dart';
import '../../core/utils/validators.dart';
import 'app_state_view_model.dart';
import 'view_state.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({required AppStateViewModel appState}) : _appState = appState;

  final AppStateViewModel _appState;
  ViewState _state = const ViewState();

  ViewState get state => _state;

  Future<void> submit({required String email, required String password}) async {
    final emailError = Validators.validateEmail(email);
    final passwordError = Validators.validatePassword(password);

    if (emailError != null || passwordError != null) {
      _state = ViewState(
        status: ViewStatus.error,
        message: emailError ?? passwordError,
      );
      notifyListeners();
      return;
    }

    _state = const ViewState(status: ViewStatus.loading);
    notifyListeners();
    await _appState.login(email: email.trim(), password: password.trim());
    if (_appState.state.status == ViewStatus.error) {
      _state = ViewState(status: ViewStatus.error, message: _appState.state.message);
    } else {
      _state = const ViewState(status: ViewStatus.success);
    }
    notifyListeners();
  }
}
