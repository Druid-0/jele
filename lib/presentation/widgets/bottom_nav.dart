import 'package:flutter/material.dart';

enum DashboardTab { home, schedule, grades, profile }

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.current,
    required this.onChanged,
    required this.accentColor,
  });

  final DashboardTab current;
  final ValueChanged<DashboardTab> onChanged;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: 'Главная',
            isActive: current == DashboardTab.home,
            onTap: () => onChanged(DashboardTab.home),
            accentColor: accentColor,
          ),
          _NavItem(
            icon: Icons.calendar_today_rounded,
            label: 'Расписание',
            isActive: current == DashboardTab.schedule,
            onTap: () => onChanged(DashboardTab.schedule),
            accentColor: accentColor,
          ),
          _NavItem(
            icon: Icons.auto_graph_rounded,
            label: 'Оценки',
            isActive: current == DashboardTab.grades,
            onTap: () => onChanged(DashboardTab.grades),
            accentColor: accentColor,
          ),
          _NavItem(
            icon: Icons.person_rounded,
            label: 'Профиль',
            isActive: current == DashboardTab.profile,
            onTap: () => onChanged(DashboardTab.profile),
            accentColor: accentColor,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? accentColor : const Color(0xFF9CA3AF);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }
}
