import 'package:flutter/foundation.dart';
import '../../domain/models/contact_models.dart';
import '../../domain/models/grade_models.dart';
import '../../domain/models/schedule_models.dart';
import '../../domain/models/student_profile.dart';
import '../../domain/repositories/school_repository.dart';
import 'view_state.dart';

class StudentDashboardViewModel extends ChangeNotifier {
  StudentDashboardViewModel({required SchoolRepository repository, required String studentId})
      : _repository = repository,
        _studentId = studentId;

  final SchoolRepository _repository;
  final String _studentId;

  ViewState _state = const ViewState();
  StudentProfile? _student;
  List<GradeSummary> _grades = [];
  List<ScheduleDay> _schedule = [];
  List<TeacherContact> _teachers = [];

  ViewState get state => _state;
  StudentProfile? get student => _student;
  List<GradeSummary> get grades => _grades;
  List<ScheduleDay> get schedule => _schedule;
  List<TeacherContact> get teachers => _teachers;

  Future<void> load() async {
    _state = const ViewState(status: ViewStatus.loading);
    notifyListeners();
    try {
      _student = await _repository.fetchStudentById(_studentId);
      if (_student != null) {
        _grades = await _repository.fetchGradesForStudent(_studentId);
        _schedule = await _repository.fetchScheduleForStudent(_studentId);
        _teachers = await _repository.fetchTeacherContactsForStudent(_studentId);
      }
      _state = const ViewState(status: ViewStatus.success);
    } catch (error) {
      _state = ViewState(status: ViewStatus.error, message: 'Не удалось загрузить данные');
    }
    notifyListeners();
  }
}
