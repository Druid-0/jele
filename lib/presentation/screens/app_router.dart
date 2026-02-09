import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/user_profile.dart';
import '../../domain/repositories/school_repository.dart';
import '../viewmodels/app_state_view_model.dart';
import '../viewmodels/login_view_model.dart';
import '../viewmodels/parent_dashboard_view_model.dart';
import '../viewmodels/student_dashboard_view_model.dart';
import '../viewmodels/teacher_dashboard_view_model.dart';
import '../viewmodels/view_state.dart';
import '../widgets/loading_view.dart';
import 'login_screen.dart';
import 'parent_dashboard_screen.dart';
import 'role_select_screen.dart';
import 'student_dashboard_screen.dart';
import 'teacher_dashboard_screen.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateViewModel>(
      builder: (context, appState, _) {
        if (appState.state.status == ViewStatus.loading) {
          return const Scaffold(body: LoadingView(message: 'Загружаем данные...'));
        }

        switch (appState.screen) {
          case AppScreen.login:
            return ChangeNotifierProvider(
              create: (context) => LoginViewModel(appState: appState),
              child: const LoginScreen(),
            );
          case AppScreen.roleSelect:
            return const RoleSelectScreen();
          case AppScreen.dashboard:
            return _buildDashboard(context, appState);
        }
      },
    );
  }

  Widget _buildDashboard(BuildContext context, AppStateViewModel appState) {
    final repository = context.read<SchoolRepository>();
    final role = appState.selectedRole ?? UserRole.parent;

    switch (role) {
      case UserRole.parent:
        return ChangeNotifierProvider(
          create: (_) => ParentDashboardViewModel(
            repository: repository,
            parentId: appState.currentUser?.id ?? 'user_parent',
          )..load(),
          child: const ParentDashboardScreen(),
        );
      case UserRole.teacher:
        return ChangeNotifierProvider(
          create: (_) => TeacherDashboardViewModel(
            repository: repository,
            teacherId: appState.currentUser?.id ?? 'user_teacher',
          )..load(),
          child: const TeacherDashboardScreen(),
        );
      case UserRole.student:
        return ChangeNotifierProvider(
          create: (_) => StudentDashboardViewModel(
            repository: repository,
            studentId: appState.currentUser?.linkedStudentId ?? 'student_1',
          )..load(),
          child: const StudentDashboardScreen(),
        );
    }
  }
}
