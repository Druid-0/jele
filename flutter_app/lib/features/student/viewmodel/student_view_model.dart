import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result.dart';
import '../../../domain/entities/contact.dart';
import '../../../domain/entities/grade.dart';
import '../../../domain/entities/schedule_day.dart';
import '../../../domain/entities/student.dart';
import '../../../domain/repositories/student_repository.dart';
import '../../shared/providers.dart';

class StudentState {
  final Result<Student> student;
  final Result<List<GradeSummary>> grades;
  final Result<List<ScheduleDay>> schedule;
  final Result<List<Contact>> teachers;

  const StudentState({
    required this.student,
    required this.grades,
    required this.schedule,
    required this.teachers,
  });

  StudentState copyWith({
    Result<Student>? student,
    Result<List<GradeSummary>>? grades,
    Result<List<ScheduleDay>>? schedule,
    Result<List<Contact>>? teachers,
  }) {
    return StudentState(
      student: student ?? this.student,
      grades: grades ?? this.grades,
      schedule: schedule ?? this.schedule,
      teachers: teachers ?? this.teachers,
    );
  }
}

class StudentViewModel extends StateNotifier<StudentState> {
  StudentViewModel(this._repository)
      : super(
          const StudentState(
            student: Result.loading(),
            grades: Result.loading(),
            schedule: Result.loading(),
            teachers: Result.loading(),
          ),
        );

  final StudentRepository _repository;

  Future<void> load(int studentId) async {
    try {
      final student = await _repository.fetchStudentInfo(studentId);
      state = state.copyWith(student: Result.success(student));
      await Future.wait([
        _loadGrades(student.id),
        _loadSchedule(student.id),
        _loadTeachers(),
      ]);
    } catch (e) {
      state = state.copyWith(student: Result.error(e.toString()));
    }
  }

  Future<void> _loadGrades(int studentId) async {
    try {
      final grades = await _repository.fetchGrades(studentId);
      state = state.copyWith(grades: Result.success(grades));
    } catch (e) {
      state = state.copyWith(grades: Result.error(e.toString()));
    }
  }

  Future<void> _loadSchedule(int studentId) async {
    try {
      final schedule = await _repository.fetchSchedule(studentId);
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

final studentViewModelProvider = StateNotifierProvider<StudentViewModel, StudentState>((ref) {
  return StudentViewModel(ref.read(studentRepositoryProvider));
});
