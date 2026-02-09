import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result.dart';
import '../../../domain/entities/contact.dart';
import '../../../domain/entities/grade.dart';
import '../../../domain/entities/schedule_day.dart';
import '../../../domain/entities/student.dart';
import '../../../domain/repositories/parent_repository.dart';
import '../../shared/providers.dart';

class ParentState {
  final Result<List<Student>> children;
  final Result<List<GradeSummary>> grades;
  final Result<List<ScheduleDay>> schedule;
  final Result<List<Contact>> teachers;
  final Student? selectedChild;

  const ParentState({
    required this.children,
    required this.grades,
    required this.schedule,
    required this.teachers,
    required this.selectedChild,
  });

  ParentState copyWith({
    Result<List<Student>>? children,
    Result<List<GradeSummary>>? grades,
    Result<List<ScheduleDay>>? schedule,
    Result<List<Contact>>? teachers,
    Student? selectedChild,
  }) {
    return ParentState(
      children: children ?? this.children,
      grades: grades ?? this.grades,
      schedule: schedule ?? this.schedule,
      teachers: teachers ?? this.teachers,
      selectedChild: selectedChild ?? this.selectedChild,
    );
  }
}

class ParentViewModel extends StateNotifier<ParentState> {
  ParentViewModel(this._repository)
      : super(
          const ParentState(
            children: Result.loading(),
            grades: Result.loading(),
            schedule: Result.loading(),
            teachers: Result.loading(),
            selectedChild: null,
          ),
        );

  final ParentRepository _repository;

  Future<void> load(int parentUserId) async {
    try {
      final children = await _repository.fetchChildren(parentUserId);
      final selected = children.isNotEmpty ? children.first : null;
      state = state.copyWith(children: Result.success(children), selectedChild: selected);
      await Future.wait([
        _loadGrades(selected),
        _loadSchedule(selected),
        _loadTeachers(),
      ]);
    } catch (e) {
      state = state.copyWith(children: Result.error(e.toString()));
    }
  }

  Future<void> selectChild(Student child) async {
    state = state.copyWith(selectedChild: child);
    await _loadGrades(child);
    await _loadSchedule(child);
  }

  Future<void> _loadGrades(Student? child) async {
    if (child == null) return;
    state = state.copyWith(grades: const Result.loading());
    try {
      final grades = await _repository.fetchGradesForChild(child.id);
      state = state.copyWith(grades: Result.success(grades));
    } catch (e) {
      state = state.copyWith(grades: Result.error(e.toString()));
    }
  }

  Future<void> _loadSchedule(Student? child) async {
    if (child == null) return;
    state = state.copyWith(schedule: const Result.loading());
    try {
      final schedule = await _repository.fetchScheduleForChild(child.id);
      state = state.copyWith(schedule: Result.success(schedule));
    } catch (e) {
      state = state.copyWith(schedule: Result.error(e.toString()));
    }
  }

  Future<void> _loadTeachers() async {
    try {
      final teachers = await _repository.fetchTeachers();
      state = state.copyWith(teachers: Result.success(teachers));
    } catch (e) {
      state = state.copyWith(teachers: Result.error(e.toString()));
    }
  }
}

final parentViewModelProvider = StateNotifierProvider<ParentViewModel, ParentState>((ref) {
  return ParentViewModel(ref.read(parentRepositoryProvider));
});
