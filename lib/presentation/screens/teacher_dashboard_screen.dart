import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/models/class_group.dart';
import '../viewmodels/app_state_view_model.dart';
import '../viewmodels/teacher_dashboard_view_model.dart';
import '../viewmodels/view_state.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/grade_chip.dart';
import '../widgets/loading_view.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_card.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  DashboardTab _activeTab = DashboardTab.home;
  bool _showClassSelector = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherDashboardViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.state.status == ViewStatus.loading) {
          return const Scaffold(body: LoadingView(message: 'Загрузка...'));
        }
        if (viewModel.state.status == ViewStatus.error) {
          return Scaffold(body: Center(child: Text(viewModel.state.message ?? 'Ошибка')));
        }

        return Scaffold(
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                decoration: const BoxDecoration(
                  color: AppColors.accentGreen,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Преподаватель',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                        Text(
                          'Математика',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: context.read<AppStateViewModel>().logout,
                      icon: const Icon(Icons.logout, color: Colors.white),
                      style: IconButton.styleFrom(backgroundColor: const Color(0xFF22C55E)),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildTabContent(context, viewModel)),
            ],
          ),
          bottomNavigationBar: BottomNav(
            current: _activeTab,
            onChanged: (tab) => setState(() => _activeTab = tab),
            accentColor: AppColors.accentGreen,
          ),
        );
      },
    );
  }

  Widget _buildTabContent(BuildContext context, TeacherDashboardViewModel viewModel) {
    switch (_activeTab) {
      case DashboardTab.home:
        return _buildHomeTab(context, viewModel);
      case DashboardTab.schedule:
        return _buildScheduleTab(context, viewModel);
      case DashboardTab.grades:
        return _buildGradesTab(context, viewModel);
      case DashboardTab.profile:
        return _buildProfileTab(context, viewModel);
    }
  }

  Widget _buildHomeTab(BuildContext context, TeacherDashboardViewModel viewModel) {
    final totalStudents = viewModel.classGroups.fold<int>(
      0,
      (sum, group) => sum + group.students.length,
    );
    final totalLessons = viewModel.schedule.fold<int>(
      0,
      (sum, day) => sum + day.lessons.length,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.groups,
                iconColor: const Color(0xFF3B82F6),
                iconBackground: const Color(0xFFDBEAFE),
                title: 'Учеников',
                value: totalStudents.toString(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.calendar_today,
                iconColor: const Color(0xFF7C3AED),
                iconBackground: const Color(0xFFEDE9FE),
                title: 'Уроков',
                value: totalLessons.toString(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Мои классы'),
        const SizedBox(height: 12),
        ...viewModel.classGroups.map(
          (group) => Container(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.name, style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      '${group.students.length} учеников',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.groups, color: AppColors.accentGreen),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Сегодня'),
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
              children: viewModel.schedule.first.lessons.map((lesson) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 70,
                        child: Text(
                          lesson.time,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.accentGreen,
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
                              'Класс ${lesson.teacher}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                            ),
                            Text(
                              'Кабинет ${lesson.room}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
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

  Widget _buildScheduleTab(BuildContext context, TeacherDashboardViewModel viewModel) {
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
                    color: AppColors.accentGreen,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Text(
                    day.day,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
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
                                      color: AppColors.accentGreen,
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
                                    'Класс ${lesson.teacher}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                                  ),
                                  Text(
                                    'Кабинет ${lesson.room}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
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

  Widget _buildGradesTab(BuildContext context, TeacherDashboardViewModel viewModel) {
    final selectedClass = viewModel.selectedClass;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GestureDetector(
          onTap: () => setState(() => _showClassSelector = !_showClassSelector),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Выбранный класс',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    ),
                    Text(
                      selectedClass?.name ?? '-',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                Icon(_showClassSelector ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        if (_showClassSelector)
          Container(
            margin: const EdgeInsets.only(top: 12),
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
              children: viewModel.classGroups.map((group) {
                return ListTile(
                  title: Text(group.name),
                  subtitle: Text('${group.students.length} учеников'),
                  selected: selectedClass?.id == group.id,
                  onTap: () async {
                    await viewModel.selectClass(group);
                    setState(() => _showClassSelector = false);
                  },
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 16),
        if (selectedClass != null) ..._buildStudentsGrades(context, viewModel, selectedClass),
      ],
    );
  }

  List<Widget> _buildStudentsGrades(
    BuildContext context,
    TeacherDashboardViewModel viewModel,
    ClassGroup selectedClass,
  ) {
    return selectedClass.students.map((student) {
      final grades = viewModel.gradesByStudent[student.id] ?? [];
      final average = viewModel.averageForStudent(student.id);
      final averageColor = _averageColor(average);

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.name, style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      student.className,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Text(
                  average > 0 ? average.toStringAsFixed(2) : '-',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: averageColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: grades.map((grade) => GradeChip(value: grade, size: 28)).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [5, 4, 3, 2].map((grade) {
                final color = _gradeColor(grade);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () => viewModel.addGrade(
                        studentId: student.id,
                        subject: 'Математика',
                        value: grade,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text('$grade', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildProfileTab(BuildContext context, TeacherDashboardViewModel viewModel) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Родители', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...viewModel.parents.map(
          (parent) => Container(
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
                Text(parent.name, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  parent.role,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                _ContactRow(icon: Icons.phone, label: parent.phone, color: const Color(0xFFF3F4F6)),
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

  Color _averageColor(double avg) {
    if (avg >= 4.5) return const Color(0xFF16A34A);
    if (avg >= 3.5) return const Color(0xFF3B82F6);
    if (avg >= 2.5) return const Color(0xFFFACC15);
    return const Color(0xFFEF4444);
  }

  Color _gradeColor(int grade) {
    switch (grade) {
      case 5:
        return const Color(0xFF22C55E);
      case 4:
        return const Color(0xFF3B82F6);
      case 3:
        return const Color(0xFFFACC15);
      default:
        return const Color(0xFFEF4444);
    }
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
            child: Icon(icon, size: 16, color: AppColors.accentGreen),
          ),
          const SizedBox(width: 10),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
