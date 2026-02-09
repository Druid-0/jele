import 'package:flutter/foundation.dart';
import '../../domain/models/class_group.dart';
import '../../domain/models/contact_models.dart';
import '../../domain/models/grade_models.dart';
import '../../domain/models/schedule_models.dart';
import '../../domain/repositories/school_repository.dart';
import 'view_state.dart';

class TeacherDashboardViewModel extends ChangeNotifier {
  TeacherDashboardViewModel({required SchoolRepository repository, required String teacherId})
      : _repository = repository,
        _teacherId = teacherId;

  final SchoolRepository _repository;
  final String _teacherId;

  ViewState _state = const ViewState();
  List<ClassGroup> _classGroups = [];
  ClassGroup? _selectedClass;
  List<ScheduleDay> _schedule = [];
  List<ParentContact> _parents = [];
  Map<String, List<int>> _gradesByStudent = {};

  ViewState get state => _state;
  List<ClassGroup> get classGroups => _classGroups;
  ClassGroup? get selectedClass => _selectedClass;
  List<ScheduleDay> get schedule => _schedule;
  List<ParentContact> get parents => _parents;
  Map<String, List<int>> get gradesByStudent => _gradesByStudent;

  Future<void> load() async {
    _state = const ViewState(status: ViewStatus.loading);
    notifyListeners();
    try {
      _classGroups = await _repository.fetchClassGroupsForTeacher(_teacherId);
      _selectedClass ??= _classGroups.isNotEmpty ? _classGroups.first : null;
      _schedule = await _repository.fetchScheduleForTeacher(_teacherId);
      _parents = await _repository.fetchParentContactsForTeacher(_teacherId);
      await _loadGradesForSelectedClass();
      _state = const ViewState(status: ViewStatus.success);
    } catch (error) {
      _state = ViewState(status: ViewStatus.error, message: 'Не удалось загрузить данные');
    }
    notifyListeners();
  }

  Future<void> selectClass(ClassGroup group) async {
    _selectedClass = group;
    notifyListeners();
    await _loadGradesForSelectedClass();
    notifyListeners();
  }

  Future<void> addGrade({required String studentId, required String subject, required int value}) async {
    await _repository.addGrade(studentId: studentId, subject: subject, value: value);
    await _loadGradesForSelectedClass();
    notifyListeners();
  }

  double averageForStudent(String studentId) {
    final grades = _gradesByStudent[studentId] ?? [];
    if (grades.isEmpty) {
      return 0;
    }
    final total = grades.fold<int>(0, (sum, value) => sum + value);
    return total / grades.length;
  }

  Future<void> _loadGradesForSelectedClass() async {
    if (_selectedClass == null) {
      return;
    }
    final result = <String, List<int>>{};
    for (final student in _selectedClass!.students) {
      final grades = await _repository.fetchGradesForStudent(student.id);
      final mathGrades = grades
          .firstWhere(
            (entry) => entry.subject == 'Математика',
            orElse: () => const GradeSummary(subject: 'Математика', average: 0, grades: []),
          )
          .grades;
      result[student.id] = mathGrades;
    }
    _gradesByStudent = result;
  }
}
