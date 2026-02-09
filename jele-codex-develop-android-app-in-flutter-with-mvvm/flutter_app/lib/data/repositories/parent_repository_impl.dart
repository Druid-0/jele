import '../../domain/entities/contact.dart';
import '../../domain/entities/grade.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/schedule_day.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/parent_repository.dart';
import '../datasources/local/db/app_database.dart';

class ParentRepositoryImpl implements ParentRepository {
  final AppDatabase _db;

  ParentRepositoryImpl(this._db);

  @override
  Future<List<Student>> fetchChildren(int parentUserId) async {
    final links = await _db.parentChildDao.getChildrenForParent(parentUserId);
    final studentIds = links.map((e) => e.studentId).toList();
    final students = await _db.studentDao.getStudentsByIds(studentIds);
    return students
        .map((s) => Student(id: s.id, name: s.name, className: s.className))
        .toList();
  }

  @override
  Future<List<GradeSummary>> fetchGradesForChild(int studentId) async {
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
  Future<List<ScheduleDay>> fetchScheduleForChild(int studentId) async {
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
