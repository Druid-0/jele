import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/view/login_screen.dart';
import '../features/auth/view/role_select_screen.dart';
import '../features/auth/viewmodel/app_state.dart';
import '../features/auth/viewmodel/app_view_model.dart';
import '../features/parent/view/parent_app.dart';
import '../features/student/view/student_app.dart';
import '../features/teacher/view/teacher_app.dart';
import '../features/shared/widgets/mobile_frame.dart';
import 'theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appViewModelProvider);

    Widget screen;
    switch (appState.screen) {
      case AppScreen.login:
        screen = const LoginScreen();
        break;
      case AppScreen.roleSelect:
        screen = const RoleSelectScreen();
        break;
      case AppScreen.parentApp:
        screen = ParentApp(user: appState.user!);
        break;
      case AppScreen.teacherApp:
        screen = TeacherApp(user: appState.user!);
        break;
      case AppScreen.studentApp:
        screen = StudentApp(user: appState.user!);
        break;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: MobileFrame(child: screen),
    );
  }
}
