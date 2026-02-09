import 'package:flutter/foundation.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/school_repository.dart';
import 'view_state.dart';

enum AppScreen { login, roleSelect, dashboard }

class AppStateViewModel extends ChangeNotifier {
  AppStateViewModel({required SchoolRepository repository}) : _repository = repository {
    _initialize();
  }

  final SchoolRepository _repository;
  UserProfile? _currentUser;
  UserRole? _selectedRole;
  AppScreen _screen = AppScreen.login;
  ViewState _state = const ViewState();

  UserProfile? get currentUser => _currentUser;
  UserRole? get selectedRole => _selectedRole;
  AppScreen get screen => _screen;
  ViewState get state => _state;

  Future<void> _initialize() async {
    _setState(const ViewState(status: ViewStatus.loading));
    await _repository.seedIfNeeded();
    _setState(const ViewState(status: ViewStatus.success));
  }

  Future<void> login({required String email, required String password}) async {
    _setState(const ViewState(status: ViewStatus.loading));
    final user = await _repository.authenticate(email: email, password: password);
    if (user == null) {
      _setState(const ViewState(status: ViewStatus.error, message: 'Неверный email или пароль'));
      return;
    }
    _currentUser = user;
    _screen = AppScreen.roleSelect;
    _setState(const ViewState(status: ViewStatus.success));
  }

  void selectRole(UserRole role) {
    _selectedRole = role;
    _screen = AppScreen.dashboard;
    notifyListeners();
  }

  void backToLogin() {
    _screen = AppScreen.login;
    _selectedRole = null;
    _currentUser = null;
    notifyListeners();
  }

  void logout() {
    _screen = AppScreen.login;
    _selectedRole = null;
    _currentUser = null;
    notifyListeners();
  }

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }
}
