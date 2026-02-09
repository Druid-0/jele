import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/color_scheme.dart';
import '../../../core/result.dart';
import '../../../domain/entities/grade.dart';
import '../../../domain/entities/user.dart';
import '../../auth/viewmodel/app_view_model.dart';
import '../../shared/widgets/bottom_nav.dart';
import '../viewmodel/student_view_model.dart';

class StudentApp extends ConsumerStatefulWidget {
  final User user;

  const StudentApp({super.key, required this.user});

  @override
  ConsumerState<StudentApp> createState() => _StudentAppState();
}

class _StudentAppState extends ConsumerState<StudentApp> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final studentId = widget.user.profileId ?? 1;
      ref.read(studentViewModelProvider.notifier).load(studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studentViewModelProvider);

    return Stack(
      children: [
        Column(
          children: [
            _buildHeader(state),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  _buildHome(state),
                  _buildSchedule(state),
                  _buildGrades(state),
                  _buildProfile(state),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: BottomNav(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            activeColor: AppColors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(StudentState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.blue,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: state.student.when(
        loading: () => const SizedBox(height: 60),
        error: (message) => Text(message, style: const TextStyle(color: Colors.white)),
        success: (student) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Класс ${student.className}',
                      style: const TextStyle(color: Color(0xFFBFDBFE), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () => ref.read(appViewModelProvider.notifier).logout(),
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHome(StudentState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStats(state),
          const SizedBox(height: 16),
          _buildPerformance(state),
          const SizedBox(height: 16),
          _buildRecentGrades(state),
          const SizedBox(height: 16),
          _buildTodaySchedule(state),
        ],
      ),
    );
  }

  Widget _buildStats(StudentState state) {
    if (state.grades is! Success<List>) {
      return const Center(child: CircularProgressIndicator());
    }
    final grades = (state.grades as Success<List>).data;
    final average = grades.isEmpty
        ? 0
        : grades.map((g) => g.average).reduce((a, b) => a + b) / grades.length;

    return Row(
      children: [
        Expanded(
          child: _InfoCard(
            icon: Icons.emoji_events,
            title: 'Средний балл',
            value: average.toStringAsFixed(1),
            color: const Color(0xFF16A34A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoCard(
            icon: Icons.menu_book,
            title: 'Предметов',
            value: grades.length.toString(),
            color: AppColors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformance(StudentState state) {
    if (state.grades is! Success<List>) {
      return const SizedBox.shrink();
    }
    final grades = (state.grades as Success<List>).data;
    final average = grades.isEmpty
        ? 0
        : grades.map((g) => g.average).reduce((a, b) => a + b) / grades.length;
    final percent = (average / 5 * 100).clamp(0, 100);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.blue, AppColors.blueDark]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Твоя успеваемость',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text(
            'Ты отлично справляешься! Продолжай в том же духе 🎉',
            style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: percent / 100,
                    minHeight: 8,
                    backgroundColor: const Color(0xFF3B82F6),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('${percent.toStringAsFixed(0)}%',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentGrades(StudentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Последние оценки', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        state.grades.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Text(message),
          success: (grades) => Column(
            children: grades.take(3).map((grade) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(grade.subject, style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text(
                          grade.average.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _averageColor(grade.average),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: grade.grades.take(5).map((value) => _GradeChip(value: value)).toList(),
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

  Widget _buildTodaySchedule(StudentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Сегодня', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        state.schedule.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Text(message),
          success: (schedule) {
            if (schedule.isEmpty) return const Text('Нет расписания');
            final today = schedule.first;
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                children: today.lessons.take(3).map((lesson) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            lesson.time.split(' - ').first,
                            style: const TextStyle(color: AppColors.blue, fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lesson.subject, style: const TextStyle(fontWeight: FontWeight.w600)),
                              Text(
                                lesson.teacher,
                                style: const TextStyle(fontSize: 12, color: AppColors.gray600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSchedule(StudentState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Расписание', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          state.schedule.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Text(message),
            success: (schedule) => Column(
              children: schedule.map((day) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Text(
                          day.day,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: day.lessons.map((lesson) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      lesson.time,
                                      style: const TextStyle(color: AppColors.blue, fontSize: 12),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(lesson.subject,
                                            style: const TextStyle(fontWeight: FontWeight.w600)),
                                        Text(
                                          lesson.teacher,
                                          style:
                                              const TextStyle(fontSize: 12, color: AppColors.gray600),
                                        ),
                                        Text(
                                          'Кабинет ${lesson.room}',
                                          style:
                                              const TextStyle(fontSize: 12, color: AppColors.gray600),
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
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrades(StudentState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Мои оценки', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          state.grades.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Text(message),
            success: (grades) => Column(
              children: grades.map((grade) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(grade.subject, style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                            grade.average.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _averageColor(grade.average),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: grade.grades.map((value) => _GradeChip(value: value)).toList(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Всего оценок: ${grade.grades.length}',
                            style: const TextStyle(fontSize: 12, color: AppColors.gray600),
                          ),
                          const Text('Динамика: +0.2',
                              style: TextStyle(fontSize: 12, color: AppColors.gray600)),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile(StudentState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStudentCard(state),
          const SizedBox(height: 16),
          const Text('Преподаватели', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          state.teachers.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Text(message),
            success: (teachers) => Column(
              children: teachers.map((teacher) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(teacher.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      if (teacher.subject != null)
                        Text(
                          teacher.subject!,
                          style: const TextStyle(color: AppColors.blue, fontSize: 12),
                        ),
                      const SizedBox(height: 12),
                      _ContactRow(icon: Icons.phone, text: teacher.phone, color: AppColors.blue),
                      const SizedBox(height: 8),
                      _ContactRow(
                        icon: Icons.chat,
                        text: 'WhatsApp',
                        color: const Color(0xFF16A34A),
                      ),
                      const SizedBox(height: 8),
                      _ContactRow(
                        icon: Icons.send,
                        text: 'Telegram',
                        color: const Color(0xFF2563EB),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(StudentState state) {
    return state.student.when(
      loading: () => const SizedBox.shrink(),
      error: (message) => Text(message),
      success: (student) {
        final average = state.grades is Success<List>
            ? _calculateAverage((state.grades as Success<List>).data)
            : 0.0;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(Icons.person, color: AppColors.blue, size: 32),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('Класс ${student.className}',
                          style: const TextStyle(color: AppColors.gray600, fontSize: 12)),
                      Text('ID: ${student.id}',
                          style: const TextStyle(color: AppColors.gray600, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(average.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF16A34A))),
                        const Text('Средний балл', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          state.grades is Success<List>
                              ? (state.grades as Success<List>).data.length.toString()
                              : '0',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.blue),
                        ),
                        const Text('Предметов', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _averageColor(double average) {
    if (average >= 4.5) return const Color(0xFF16A34A);
    if (average >= 3.5) return const Color(0xFF2563EB);
    if (average >= 2.5) return const Color(0xFFF59E0B);
    return const Color(0xFFDC2626);
  }

  double _calculateAverage(List<GradeSummary> grades) {
    if (grades.isEmpty) return 0;
    final values = grades.map((g) => g.average).toList();
    return values.reduce((a, b) => a + b) / values.length;
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.gray600)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

class _GradeChip extends StatelessWidget {
  final int value;

  const _GradeChip({required this.value});

  @override
  Widget build(BuildContext context) {
    Color color;
    if (value == 5) {
      color = const Color(0xFF16A34A);
    } else if (value == 4) {
      color = const Color(0xFF2563EB);
    } else if (value == 3) {
      color = const Color(0xFFF59E0B);
    } else {
      color = const Color(0xFFDC2626);
    }
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(
        value.toString(),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _ContactRow({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
