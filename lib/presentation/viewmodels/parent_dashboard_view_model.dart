import 'package:flutter/foundation.dart';
import '../../domain/models/contact_models.dart';
import '../../domain/models/grade_models.dart';
import '../../domain/models/schedule_models.dart';
import '../../domain/models/student_profile.dart';
import '../../domain/repositories/school_repository.dart';
import 'view_state.dart';

class ParentDashboardViewModel extends ChangeNotifier {
  ParentDashboardViewModel({required SchoolRepository repository, required String parentId})
      : _repository = repository,
        _parentId = parentId;

  final SchoolRepository _repository;
  final String _parentId;

  ViewState _state = const ViewState();
  List<StudentProfile> _children = [];
  StudentProfile? _selectedChild;
  List<GradeSummary> _grades = [];
  List<ScheduleDay> _schedule = [];
  List<TeacherContact> _teachers = [];

  ViewState get state => _state;
  List<StudentProfile> get children => _children;
  StudentProfile? get selectedChild => _selectedChild;
  List<GradeSummary> get grades => _grades;
  List<ScheduleDay> get schedule => _schedule;
  List<TeacherContact> get teachers => _teachers;

  Future<void> load() async {
    _state = const ViewState(status: ViewStatus.loading);
    notifyListeners();
    try {
      _children = await _repository.fetchChildrenForParent(_parentId);
      _selectedChild ??= _children.isNotEmpty ? _children.first : null;
      if (_selectedChild != null) {
        await _loadChildData(_selectedChild!);
      }
      _state = const ViewState(status: ViewStatus.success);
    } catch (error) {
      _state = ViewState(status: ViewStatus.error, message: 'Не удалось загрузить данные');
    }
    notifyListeners();
  }

  Future<void> selectChild(StudentProfile child) async {
    _selectedChild = child;
    notifyListeners();
    await _loadChildData(child);
    notifyListeners();
  }

  Future<void> _loadChildData(StudentProfile child) async {
    _grades = await _repository.fetchGradesForStudent(child.id);
    _schedule = await _repository.fetchScheduleForStudent(child.id);
    _teachers = await _repository.fetchTeacherContactsForStudent(child.id);
  }
}
