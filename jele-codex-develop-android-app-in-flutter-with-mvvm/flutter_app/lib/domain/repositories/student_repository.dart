import '../entities/contact.dart';
import '../entities/grade.dart';
import '../entities/schedule_day.dart';
import '../entities/student.dart';

abstract class StudentRepository {
  Future<Student> fetchStudentInfo(int studentId);
  Future<List<GradeSummary>> fetchGrades(int studentId);
  Future<List<ScheduleDay>> fetchSchedule(int studentId);
  Future<List<Contact>> fetchTeachers();
}
