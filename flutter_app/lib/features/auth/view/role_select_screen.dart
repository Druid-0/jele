import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/color_scheme.dart';
import '../../../domain/entities/user.dart';
import '../viewmodel/app_view_model.dart';

class RoleSelectScreen extends ConsumerWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          color: AppColors.blue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => ref.read(appViewModelProvider.notifier).backToLogin(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text('Назад', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 12),
              const Text(
                'Выберите роль',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              const Text(
                'Как вы будете использовать приложение?',
                style: TextStyle(color: Color(0xFFBFDBFE)),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _RoleCard(
                  title: 'Родитель',
                  description:
                      'Отслеживайте успеваемость детей, просматривайте расписание и общайтесь с преподавателями',
                  icon: Icons.groups,
                  color: const Color(0xFF7C3AED),
                  background: const Color(0xFFEDE9FE),
                  onTap: () =>
                      ref.read(appViewModelProvider.notifier).selectRole(UserRole.parent),
                ),
                const SizedBox(height: 16),
                _RoleCard(
                  title: 'Преподаватель',
                  description:
                      'Управляйте расписанием, ведите электронный журнал и выставляйте оценки ученикам',
                  icon: Icons.menu_book,
                  color: AppColors.green,
                  background: const Color(0xFFDCFCE7),
                  onTap: () =>
                      ref.read(appViewModelProvider.notifier).selectRole(UserRole.teacher),
                ),
                const SizedBox(height: 16),
                _RoleCard(
                  title: 'Ученик',
                  description:
                      'Просматривайте расписание занятий, свои оценки и контакты преподавателей',
                  icon: Icons.person,
                  color: AppColors.blue,
                  background: const Color(0xFFDBEAFE),
                  onTap: () =>
                      ref.read(appViewModelProvider.notifier).selectRole(UserRole.student),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          color: Colors.white,
          child: const Center(
            child: Text(
              'Демо-версия приложения с тестовыми данными',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.transparent, width: 2),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: background, shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
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
