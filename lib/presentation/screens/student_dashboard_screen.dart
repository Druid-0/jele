import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/models/grade_models.dart';
import '../viewmodels/app_state_view_model.dart';
import '../viewmodels/student_dashboard_view_model.dart';
import '../viewmodels/view_state.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/grade_chip.dart';
import '../widgets/loading_view.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_card.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  DashboardTab _activeTab = DashboardTab.home;

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentDashboardViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.state.status == ViewStatus.loading) {
          return const Scaffold(body: LoadingView(message: 'Загрузка...'));
        }
        if (viewModel.state.status == ViewStatus.error) {
          return Scaffold(body: Center(child: Text(viewModel.state.message ?? 'Ошибка')));
        }

        final student = viewModel.student;
        final grades = viewModel.grades;
        final average = _calculateAverage(grades);

        return Scaffold(
          body: Column(
            children: [
              Container(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3B82F6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student?.name ?? '-',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                            ),
                            Text(
                              'Класс ${student?.className ?? '-'}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: context.read<AppStateViewModel>().logout,
                      icon: const Icon(Icons.logout, color: Colors.white),
                      style: IconButton.styleFrom(backgroundColor: const Color(0xFF3B82F6)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildTabContent(context, viewModel, average),
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

  Widget _buildTabContent(BuildContext context, StudentDashboardViewModel viewModel, double average) {
    switch (_activeTab) {
      case DashboardTab.home:
        return _buildHomeTab(context, viewModel, average);
      case DashboardTab.schedule:
        return _buildScheduleTab(context, viewModel);
      case DashboardTab.grades:
        return _buildGradesTab(context, viewModel);
      case DashboardTab.profile:
        return _buildProfileTab(context, viewModel, average);
    }
  }

  Widget _buildHomeTab(BuildContext context, StudentDashboardViewModel viewModel, double average) {
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
                value: average.toStringAsFixed(1),
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
                value: viewModel.grades.length.toString(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryBlue, Color(0xFF1D4ED8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Твоя успеваемость',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                'Ты отлично справляешься! Продолжай в том же духе 🎉',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: average / 5,
                        minHeight: 6,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${((average / 5) * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Последние оценки'),
        const SizedBox(height: 12),
        ...viewModel.grades.take(3).map((grade) => _GradeCard(grade: grade)),
        const SizedBox(height: 16),
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
              children: viewModel.schedule.first.lessons.take(3).map((lesson) {
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

  Widget _buildScheduleTab(BuildContext context, StudentDashboardViewModel viewModel) {
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

  Widget _buildGradesTab(BuildContext context, StudentDashboardViewModel viewModel) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Мои оценки', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...viewModel.grades.map((grade) => _GradeDetailCard(grade: grade)),
      ],
    );
  }

  Widget _buildProfileTab(
    BuildContext context,
    StudentDashboardViewModel viewModel,
    double average,
  ) {
    final student = viewModel.student;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
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
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDBEAFE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: AppColors.primaryBlue, size: 30),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student?.name ?? '-', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        'Класс ${student?.className ?? '-'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                      ),
                      Text('ID: ${student?.id ?? '-'}', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ProfileStat(label: 'Средний балл', value: average.toStringAsFixed(1), color: const Color(0xFF16A34A)),
                  _ProfileStat(label: 'Предметов', value: viewModel.grades.length.toString(), color: AppColors.primaryBlue),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Преподаватели', style: Theme.of(context).textTheme.titleMedium),
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
                _ContactRow(icon: Icons.phone, label: teacher.phone, color: const Color(0xFFF3F4F6)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Всего оценок: ${grade.grades.length}', style: Theme.of(context).textTheme.bodySmall),
              Text('Динамика: +0.2', style: Theme.of(context).textTheme.bodySmall),
            ],
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

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
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
