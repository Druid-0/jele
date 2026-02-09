import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result.dart';
import '../../../domain/entities/class_group.dart';
import '../../../domain/entities/contact.dart';
import '../../../domain/entities/grade.dart';
import '../../../domain/entities/schedule_day.dart';
import '../../../domain/entities/student.dart';
import '../../../domain/repositories/teacher_repository.dart';
import '../../shared/providers.dart';

class TeacherState {
  final Result<List<ClassGroup>> classGroups;
  final Result<List<ScheduleDay>> schedule;
  final Result<List<Contact>> parents;
  final Result<Map<int, List<int>>> gradesByStudent;
  final ClassGroup? selectedGroup;

  const TeacherState({
    required this.classGroups,
    required this.schedule,
    required this.parents,
    required this.gradesByStudent,
    required this.selectedGroup,
  });

  TeacherState copyWith({
    Result<List<ClassGroup>>? classGroups,
    Result<List<ScheduleDay>>? schedule,
    Result<List<Contact>>? parents,
    Result<Map<int, List<int>>>? gradesByStudent,
    ClassGroup? selectedGroup,
  }) {
    return TeacherState(
      classGroups: classGroups ?? this.classGroups,
      schedule: schedule ?? this.schedule,
      parents: parents ?? this.parents,
      gradesByStudent: gradesByStudent ?? this.gradesByStudent,
      selectedGroup: selectedGroup ?? this.selectedGroup,
    );
  }
}

class TeacherViewModel extends StateNotifier<TeacherState> {
  TeacherViewModel(this._repository)
      : super(
          const TeacherState(
            classGroups: Result.loading(),
            schedule: Result.loading(),
            parents: Result.loading(),
            gradesByStudent: Result.loading(),
            selectedGroup: null,
          ),
        );

  final TeacherRepository _repository;

  Future<void> load(int teacherId) async {
    try {
      final groups = await _repository.fetchClassGroups();
      final selectedGroup = groups.isNotEmpty ? groups.first : null;
      state = state.copyWith(
        classGroups: Result.success(groups),
        selectedGroup: selectedGroup,
      );

      await Future.wait([
        _loadSchedule(teacherId),
        _loadParents(),
        _loadGradesForGroup(selectedGroup),
      ]);
    } catch (e) {
      state = state.copyWith(classGroups: Result.error(e.toString()));
    }
  }

  Future<void> selectGroup(ClassGroup group) async {
    state = state.copyWith(selectedGroup: group);
    await _loadGradesForGroup(group);
  }

  Future<void> addGrade(Student student, int grade) async {
    await _repository.addGrade(student.id, 'Математика', grade);
    await _loadGradesForGroup(state.selectedGroup);
  }

  Future<void> _loadSchedule(int teacherId) async {
    try {
      final schedule = await _repository.fetchSchedule(teacherId);
      state = state.copyWith(schedule: Result.success(schedule));
    } catch (e) {
      state = state.copyWith(schedule: Result.error(e.toString()));
    }
  }

  Future<void> _loadParents() async {
    try {
      final parents = await _repository.fetchParents();
      state = state.copyWith(parents: Result.success(parents));
    } catch (e) {
      state = state.copyWith(parents: Result.error(e.toString()));
    }
  }

  Future<void> _loadGradesForGroup(ClassGroup? group) async {
    if (group == null) return;
    state = state.copyWith(gradesByStudent: const Result.loading());
    try {
      final gradesMap = <int, List<int>>{};
      for (final student in group.students) {
        final grades = await _repository.fetchGradesForStudent(student.id);
        final math = grades.firstWhere(
          (entry) => entry.subject == 'Математика',
          orElse: () => const GradeSummary(subject: 'Математика', grades: [], average: 0),
        );
        gradesMap[student.id] = math.grades;
      }
      state = state.copyWith(gradesByStudent: Result.success(gradesMap));
    } catch (e) {
      state = state.copyWith(gradesByStudent: Result.error(e.toString()));
    }
  }
}

final teacherViewModelProvider = StateNotifierProvider<TeacherViewModel, TeacherState>((ref) {
  return TeacherViewModel(ref.read(teacherRepositoryProvider));
});
