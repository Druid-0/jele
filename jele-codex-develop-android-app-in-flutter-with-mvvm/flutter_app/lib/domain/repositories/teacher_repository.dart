import '../entities/class_group.dart';
import '../entities/contact.dart';
import '../entities/grade.dart';
import '../entities/schedule_day.dart';

abstract class TeacherRepository {
  Future<List<ClassGroup>> fetchClassGroups();
  Future<List<GradeSummary>> fetchGradesForStudent(int studentId);
  Future<List<ScheduleDay>> fetchSchedule(int teacherId);
  Future<List<Contact>> fetchParents();
  Future<void> addGrade(int studentId, String subject, int value);
}
