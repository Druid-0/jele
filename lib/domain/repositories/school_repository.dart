import '../models/class_group.dart';
import '../models/contact_models.dart';
import '../models/grade_models.dart';
import '../models/schedule_models.dart';
import '../models/student_profile.dart';
import '../models/user_profile.dart';

abstract class SchoolRepository {
  Future<UserProfile?> authenticate({
    required String email,
    required String password,
  });

  Future<UserProfile?> fetchUserById(String id);

  Future<List<StudentProfile>> fetchChildrenForParent(String parentId);
  Future<StudentProfile?> fetchStudentById(String studentId);

  Future<List<GradeSummary>> fetchGradesForStudent(String studentId);
  Future<List<ScheduleDay>> fetchScheduleForStudent(String studentId);
  Future<List<ScheduleDay>> fetchScheduleForTeacher(String teacherId);

  Future<List<TeacherContact>> fetchTeacherContactsForStudent(String studentId);
  Future<List<ParentContact>> fetchParentContactsForTeacher(String teacherId);

  Future<List<ClassGroup>> fetchClassGroupsForTeacher(String teacherId);
  Future<void> addGrade({
    required String studentId,
    required String subject,
    required int value,
  });

  Future<void> seedIfNeeded();
}
