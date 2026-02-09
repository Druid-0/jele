import '../entities/contact.dart';
import '../entities/grade.dart';
import '../entities/schedule_day.dart';
import '../entities/student.dart';

abstract class ParentRepository {
  Future<List<Student>> fetchChildren(int parentUserId);
  Future<List<GradeSummary>> fetchGradesForChild(int studentId);
  Future<List<ScheduleDay>> fetchScheduleForChild(int studentId);
  Future<List<Contact>> fetchTeachers();
}
