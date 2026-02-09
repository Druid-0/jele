import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/color_scheme.dart';
import '../../../core/result.dart';
import '../../../domain/entities/user.dart';
import '../../auth/viewmodel/app_view_model.dart';
import '../../shared/widgets/bottom_nav.dart';
import '../viewmodel/teacher_view_model.dart';

class TeacherApp extends ConsumerStatefulWidget {
  final User user;

  const TeacherApp({super.key, required this.user});

  @override
  ConsumerState<TeacherApp> createState() => _TeacherAppState();
}

class _TeacherAppState extends ConsumerState<TeacherApp> {
  int _currentIndex = 0;
  bool _showClasses = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final teacherId = widget.user.profileId ?? 1;
      ref.read(teacherViewModelProvider.notifier).load(teacherId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teacherViewModelProvider);

    return Stack(
      children: [
        Column(
          children: [
            _buildHeader(),
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
            activeColor: AppColors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.green,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Преподаватель',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Text('Математика', style: TextStyle(color: Color(0xFFDCFCE7), fontSize: 12)),
            ],
          ),
          IconButton(
            onPressed: () => ref.read(appViewModelProvider.notifier).logout(),
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildHome(TeacherState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStats(state),
          const SizedBox(height: 16),
          _buildClasses(state),
          const SizedBox(height: 16),
          _buildTodaySchedule(state),
        ],
      ),
    );
  }

  Widget _buildStats(TeacherState state) {
    if (state.classGroups is! Success<List>) {
      return const Center(child: CircularProgressIndicator());
    }
    final groups = (state.classGroups as Success<List>).data;
    final studentCount = groups.fold<int>(0, (sum, g) => sum + g.students.length);
    final lessonCount = state.schedule is Success<List>
        ? (state.schedule as Success<List>).data.fold<int>(
            0,
            (sum, day) => sum + day.lessons.length,
          )
        : 0;

    return Row(
      children: [
        Expanded(
          child: _InfoCard(
            icon: Icons.groups,
            title: 'Учеников',
            value: studentCount.toString(),
            color: AppColors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoCard(
            icon: Icons.calendar_today,
            title: 'Уроков',
            value: lessonCount.toString(),
            color: const Color(0xFF7C3AED),
          ),
        ),
      ],
    );
  }

  Widget _buildClasses(TeacherState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Мои классы', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        state.classGroups.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Text(message),
          success: (groups) => Column(
            children: groups.map((group) {
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(group.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text(
                          '${group.students.length} учеников',
                          style: const TextStyle(fontSize: 12, color: AppColors.gray600),
                        ),
                      ],
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(Icons.groups, color: AppColors.green),
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

  Widget _buildTodaySchedule(TeacherState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Сегодня', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        state.schedule.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Text(message),
          success: (schedule) {
            if (schedule.isEmpty) return const Text('Нет занятий');
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
                children: today.lessons.map((lesson) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            lesson.time,
                            style: const TextStyle(color: AppColors.green, fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lesson.subject, style: const TextStyle(fontWeight: FontWeight.w600)),
                              Text(
                                'Класс ${lesson.teacher}',
                                style: const TextStyle(fontSize: 12, color: AppColors.gray600),
                              ),
                              Text(
                                'Кабинет ${lesson.room}',
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

  Widget _buildSchedule(TeacherState state) {
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
                          color: AppColors.green,
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
                                      style: const TextStyle(color: AppColors.green, fontSize: 12),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(lesson.subject,
                                            style: const TextStyle(fontWeight: FontWeight.w600)),
                                        Text(
                                          'Класс ${lesson.teacher}',
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

  Widget _buildGrades(TeacherState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Оценки', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _buildClassSelector(state),
          const SizedBox(height: 12),
          state.classGroups.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Text(message),
            success: (groups) {
              final group = state.selectedGroup;
              if (group == null) return const Text('Нет выбранного класса');
              return Column(
                children: group.students.map((student) {
                  final grades = state.gradesByStudent is Success<Map<int, List<int>>>
                      ? (state.gradesByStudent as Success<Map<int, List<int>>>)
                              .data[student.id] ??
                          <int>[]
                      : <int>[];

                  final average = grades.isNotEmpty
                      ? grades.reduce((a, b) => a + b) / grades.length
                      : 0.0;

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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(student.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                Text(student.className,
                                    style: const TextStyle(fontSize: 12, color: AppColors.gray600)),
                              ],
                            ),
                            Text(
                              average > 0 ? average.toStringAsFixed(2) : '-',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _averageColor(average),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: grades.map((value) => _GradeChip(value: value)).toList(),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [5, 4, 3, 2].map((grade) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ElevatedButton(
                                  onPressed: () => ref
                                      .read(teacherViewModelProvider.notifier)
                                      .addGrade(student, grade),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _gradeColor(grade),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(grade.toString()),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClassSelector(TeacherState state) {
    final selected = state.selectedGroup;
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _showClasses = !_showClasses),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Выбранный класс', style: TextStyle(fontSize: 12, color: AppColors.gray600)),
                    Text(selected?.name ?? 'Выберите',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                Icon(_showClasses ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        if (_showClasses && state.classGroups is Success<List>)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              children: (state.classGroups as Success<List>)
                  .data
                  .map(
                    (group) => ListTile(
                      title: Text(group.name),
                      subtitle: Text('${group.students.length} учеников'),
                      selected: selected?.id == group.id,
                      onTap: () {
                        setState(() => _showClasses = false);
                        ref.read(teacherViewModelProvider.notifier).selectGroup(group);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildProfile(TeacherState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Родители', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          state.parents.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Text(message),
            success: (parents) => Column(
              children: parents.map((parent) {
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
                      Text(parent.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(parent.role,
                          style: const TextStyle(fontSize: 12, color: AppColors.gray600)),
                      const SizedBox(height: 12),
                      _ContactRow(icon: Icons.phone, text: parent.phone, color: AppColors.blue),
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

  Color _averageColor(double average) {
    if (average >= 4.5) return const Color(0xFF16A34A);
    if (average >= 3.5) return const Color(0xFF2563EB);
    if (average >= 2.5) return const Color(0xFFF59E0B);
    return const Color(0xFFDC2626);
  }

  Color _gradeColor(int value) {
    if (value == 5) return const Color(0xFF16A34A);
    if (value == 4) return const Color(0xFF2563EB);
    if (value == 3) return const Color(0xFFF59E0B);
    return const Color(0xFFDC2626);
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
      width: 32,
      height: 32,
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
