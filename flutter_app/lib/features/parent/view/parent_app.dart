import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/color_scheme.dart';
import '../../../core/result.dart';
import '../../../domain/entities/user.dart';
import '../../auth/viewmodel/app_view_model.dart';
import '../../shared/widgets/bottom_nav.dart';
import '../viewmodel/parent_view_model.dart';

class ParentApp extends ConsumerStatefulWidget {
  final User user;

  const ParentApp({super.key, required this.user});

  @override
  ConsumerState<ParentApp> createState() => _ParentAppState();
}

class _ParentAppState extends ConsumerState<ParentApp> {
  int _currentIndex = 0;
  bool _showChildren = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(parentViewModelProvider.notifier).load(widget.user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(parentViewModelProvider);

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

  Widget _buildHeader(ParentState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.blue,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Родитель',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
              ),
              IconButton(
                onPressed: () => ref.read(appViewModelProvider.notifier).logout(),
                icon: const Icon(Icons.logout, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => setState(() => _showChildren = !_showChildren),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Выбранный ребенок',
                    style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 12),
                  ),
                  Text(
                    state.selectedChild?.name ?? 'Выберите',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    state.selectedChild != null
                        ? 'Класс ${state.selectedChild!.className}'
                        : '',
                    style: const TextStyle(color: Color(0xFFBFDBFE), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          if (_showChildren && state.children is Success<List>)
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
                ],
              ),
              child: Column(
                children: (state.children as Success<List>)
                    .data
                    .map(
                      (child) => ListTile(
                        title: Text(child.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('Класс ${child.className}'),
                        selected: state.selectedChild?.id == child.id,
                        onTap: () {
                          setState(() => _showChildren = false);
                          ref.read(parentViewModelProvider.notifier).selectChild(child);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHome(ParentState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStats(state),
          const SizedBox(height: 16),
          _buildRecentGrades(state),
          const SizedBox(height: 16),
          _buildTodaySchedule(state),
        ],
      ),
    );
  }

  Widget _buildStats(ParentState state) {
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

  Widget _buildRecentGrades(ParentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Последние оценки',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
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
                      children: grade.grades.take(5).map((value) {
                        return _GradeChip(value: value);
                      }).toList(),
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

  Widget _buildTodaySchedule(ParentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Расписание на сегодня',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        state.schedule.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Text(message),
          success: (schedule) {
            if (schedule.isEmpty) {
              return const Text('Нет расписания');
            }
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
                children: today.lessons.take(2).map((lesson) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            lesson.time.split(' - ').first,
                            style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w600),
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

  Widget _buildSchedule(ParentState state) {
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

  Widget _buildGrades(ParentState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Оценки', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
                      Text(
                        'Всего оценок: ${grade.grades.length}',
                        style: const TextStyle(fontSize: 12, color: AppColors.gray600),
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

  Widget _buildProfile(ParentState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Преподаватели', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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

  Color _averageColor(double average) {
    if (average >= 4.5) return const Color(0xFF16A34A);
    if (average >= 3.5) return const Color(0xFF2563EB);
    if (average >= 2.5) return const Color(0xFFF59E0B);
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
