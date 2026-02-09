import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/models/grade_models.dart';
import '../../domain/models/student_profile.dart';
import '../viewmodels/app_state_view_model.dart';
import '../viewmodels/parent_dashboard_view_model.dart';
import '../viewmodels/view_state.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/grade_chip.dart';
import '../widgets/loading_view.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_card.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  DashboardTab _activeTab = DashboardTab.home;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParentDashboardViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.state.status == ViewStatus.loading) {
          return const Scaffold(body: LoadingView(message: 'Загрузка...'));
        }
        if (viewModel.state.status == ViewStatus.error) {
          return Scaffold(
            body: Center(child: Text(viewModel.state.message ?? 'Ошибка')),
          );
        }

        final selectedChild = viewModel.selectedChild;
        final grades = viewModel.grades;
        final overallAverage = _calculateAverage(grades);
        return Scaffold(
          body: Column(
            children: [
              _ParentHeader(
                selectedChild: selectedChild,
                children: viewModel.children,
                onSelectChild: viewModel.selectChild,
                onLogout: context.read<AppStateViewModel>().logout,
              ),
              Expanded(
                child: _buildTabContent(
                  context,
                  viewModel,
                  selectedChild,
                  grades,
                  overallAverage,
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNav(
            current: _activeTab,
            onChanged: (tab) => setState(() => _activeTab = tab),
            accentColor: AppColors.primaryBlue,
          ),
        );
      },
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    ParentDashboardViewModel viewModel,
    StudentProfile? selectedChild,
    List<GradeSummary> grades,
    double overallAverage,
  ) {
    switch (_activeTab) {
      case DashboardTab.home:
        return _buildHomeTab(context, viewModel, grades, overallAverage);
      case DashboardTab.schedule:
        return _buildScheduleTab(context, viewModel);
      case DashboardTab.grades:
        return _buildGradesTab(context, grades);
      case DashboardTab.profile:
        return _buildTeachersTab(context, viewModel);
    }
  }

  Widget _buildHomeTab(
    BuildContext context,
    ParentDashboardViewModel viewModel,
    List<GradeSummary> grades,
    double overallAverage,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.emoji_events,
                iconColor: const Color(0xFF16A34A),
                iconBackground: const Color(0xFFDCFCE7),
                title: 'Средний балл',
                value: overallAverage.toStringAsFixed(1),
                valueColor: const Color(0xFF16A34A),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.menu_book,
                iconColor: const Color(0xFF3B82F6),
                iconBackground: const Color(0xFFDBEAFE),
                title: 'Предметов',
                value: grades.length.toString(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Последние оценки'),
        const SizedBox(height: 12),
        ...grades.take(3).map((grade) => _GradeCard(grade: grade)),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Расписание на сегодня'),
        const SizedBox(height: 12),
        if (viewModel.schedule.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: viewModel.schedule.first.lessons.take(2).map((lesson) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          lesson.time.split(' - ').first,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lesson.subject, style: Theme.of(context).textTheme.bodyMedium),
                            Text(
                              lesson.teacher,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildScheduleTab(BuildContext context, ParentDashboardViewModel viewModel) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Расписание', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...viewModel.schedule.map(
          (day) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Text(
                    day.day,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: day.lessons.map((lesson) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 70,
                              child: Text(
                                lesson.time,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.primaryBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(lesson.subject, style: Theme.of(context).textTheme.bodyMedium),
                                  Text(
                                    lesson.teacher,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                  Text(
                                    'Кабинет ${lesson.room}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradesTab(BuildContext context, List<GradeSummary> grades) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Оценки', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...grades.map(
          (grade) => _GradeDetailCard(grade: grade),
        ),
      ],
    );
  }

  Widget _buildTeachersTab(BuildContext context, ParentDashboardViewModel viewModel) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Преподаватели', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...viewModel.teachers.map(
          (teacher) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(teacher.name, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  teacher.subject,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primaryBlue),
                ),
                const SizedBox(height: 12),
                _ContactRow(icon: Icons.phone, label: teacher.phone, color: const Color(0xFFEFF6FF)),
                const SizedBox(height: 8),
                _ContactRow(icon: Icons.chat_bubble, label: 'WhatsApp', color: const Color(0xFFECFDF3)),
                const SizedBox(height: 8),
                _ContactRow(icon: Icons.send, label: 'Telegram', color: const Color(0xFFEFF6FF)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _calculateAverage(List<GradeSummary> grades) {
    if (grades.isEmpty) {
      return 0;
    }
    final total = grades.fold<double>(0, (sum, grade) => sum + grade.average);
    return total / grades.length;
  }
}

class _ParentHeader extends StatefulWidget {
  const _ParentHeader({
    required this.selectedChild,
    required this.children,
    required this.onSelectChild,
    required this.onLogout,
  });

  final StudentProfile? selectedChild;
  final List<StudentProfile> children;
  final ValueChanged<StudentProfile> onSelectChild;
  final VoidCallback onLogout;

  @override
  State<_ParentHeader> createState() => _ParentHeaderState();
}

class _ParentHeaderState extends State<_ParentHeader> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Родитель',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              IconButton(
                onPressed: widget.onLogout,
                icon: const Icon(Icons.logout, color: Colors.white),
                style: IconButton.styleFrom(backgroundColor: const Color(0xFF3B82F6)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Выбранный ребенок',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.selectedChild?.name ?? '-',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
                      Text(
                        'Класс ${widget.selectedChild?.className ?? '-'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: widget.children.map((child) {
                  final isSelected = widget.selectedChild?.id == child.id;
                  return ListTile(
                    title: Text(child.name),
                    subtitle: Text('Класс ${child.className}'),
                    tileColor: isSelected ? const Color(0xFFEFF6FF) : null,
                    onTap: () {
                      widget.onSelectChild(child);
                      setState(() => _expanded = false);
                    },
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _GradeCard extends StatelessWidget {
  const _GradeCard({required this.grade});

  final GradeSummary grade;

  @override
  Widget build(BuildContext context) {
    final color = _averageColor(grade.average);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(grade.subject, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              Text(
                grade.average.toStringAsFixed(1),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: grade.grades.take(5).map((value) => GradeChip(value: value, size: 28)).toList(),
          ),
        ],
      ),
    );
  }

  Color _averageColor(double avg) {
    if (avg >= 4.5) return const Color(0xFF16A34A);
    if (avg >= 3.5) return const Color(0xFF3B82F6);
    if (avg >= 2.5) return const Color(0xFFFACC15);
    return const Color(0xFFEF4444);
  }
}

class _GradeDetailCard extends StatelessWidget {
  const _GradeDetailCard({required this.grade});

  final GradeSummary grade;

  @override
  Widget build(BuildContext context) {
    final color = _averageColor(grade.average);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(grade.subject, style: Theme.of(context).textTheme.titleMedium),
              Row(
                children: [
                  Text(
                    grade.average.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.trending_up, size: 16, color: Color(0xFF16A34A)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: grade.grades.map((value) => GradeChip(value: value)).toList(),
          ),
          const SizedBox(height: 8),
          Text('Всего оценок: ${grade.grades.length}', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Color _averageColor(double avg) {
    if (avg >= 4.5) return const Color(0xFF16A34A);
    if (avg >= 3.5) return const Color(0xFF3B82F6);
    if (avg >= 2.5) return const Color(0xFFFACC15);
    return const Color(0xFFEF4444);
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppColors.primaryBlue),
          ),
          const SizedBox(width: 10),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
