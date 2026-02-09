import '../../domain/entities/contact.dart';
import '../../domain/entities/grade.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/schedule_day.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/local/db/app_database.dart';

class StudentRepositoryImpl implements StudentRepository {
  final AppDatabase _db;

  StudentRepositoryImpl(this._db);

  @override
  Future<Student> fetchStudentInfo(int studentId) async {
    final student = await _db.studentDao.getStudentById(studentId);
    if (student == null) {
      throw Exception('Ученик не найден');
    }
    return Student(id: student.id, name: student.name, className: student.className);
  }

  @override
  Future<List<GradeSummary>> fetchGrades(int studentId) async {
    final grades = await _db.gradeDao.getGradesForStudent(studentId);
    final grouped = <String, List<int>>{};
    for (final grade in grades) {
      grouped.putIfAbsent(grade.subject, () => []).add(grade.value);
    }

    return grouped.entries.map((entry) {
      final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
      return GradeSummary(subject: entry.key, grades: entry.value, average: avg);
    }).toList();
  }

  @override
  Future<List<ScheduleDay>> fetchSchedule(int studentId) async {
    final lessons = await _db.scheduleDao.getStudentSchedule(studentId);
    final grouped = <String, List<Lesson>>{};
    for (final lesson in lessons) {
      grouped.putIfAbsent(lesson.day, () => []).add(
            Lesson(
              time: lesson.time,
              subject: lesson.subject,
              teacher: lesson.teacher,
              room: lesson.room,
            ),
          );
    }

    return grouped.entries
        .map(
          (entry) => ScheduleDay(day: entry.key, lessons: entry.value),
        )
        .toList();
  }

  @override
  Future<List<Contact>> fetchTeachers() async {
    final contacts = await _db.contactDao.getContactsByType('teacher');
    return contacts
        .map(
          (c) => Contact(
            name: c.name,
            role: c.role,
            phone: c.phone,
            whatsapp: c.whatsapp,
            telegram: c.telegram,
            subject: c.subject,
          ),
        )
        .toList();
  }
}
