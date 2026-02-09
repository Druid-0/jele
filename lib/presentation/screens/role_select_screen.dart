import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/models/user_profile.dart';
import '../viewmodels/app_state_view_model.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppStateViewModel>();
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
            decoration: const BoxDecoration(color: AppColors.primaryBlue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: appState.backToLogin,
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text('Назад', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 12),
                Text(
                  'Выберите роль',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Как вы будете использовать приложение?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _RoleCard(
                  title: 'Родитель',
                  description:
                      'Отслеживайте успеваемость детей, просматривайте расписание и общайтесь с преподавателями',
                  icon: Icons.groups,
                  accent: AppColors.accentPurple,
                  onTap: () => appState.selectRole(UserRole.parent),
                ),
                const SizedBox(height: 16),
                _RoleCard(
                  title: 'Преподаватель',
                  description:
                      'Управляйте расписанием, ведите электронный журнал и выставляйте оценки ученикам',
                  icon: Icons.menu_book,
                  accent: AppColors.accentGreen,
                  onTap: () => appState.selectRole(UserRole.teacher),
                ),
                const SizedBox(height: 16),
                _RoleCard(
                  title: 'Ученик',
                  description:
                      'Просматривайте расписание занятий, свои оценки и контакты преподавателей',
                  icon: Icons.school,
                  accent: AppColors.primaryBlue,
                  onTap: () => appState.selectRole(UserRole.student),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Text(
              'Демо-версия приложения с тестовыми данными',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.transparent, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
