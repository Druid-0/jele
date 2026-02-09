import '../../domain/entities/class_group.dart';
import '../../domain/entities/contact.dart';
import '../../domain/entities/grade.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/schedule_day.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/teacher_repository.dart';
import '../datasources/local/db/app_database.dart';
import '../datasources/local/db/tables.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final AppDatabase _db;

  TeacherRepositoryImpl(this._db);

  @override
  Future<List<ClassGroup>> fetchClassGroups() async {
    final groups = await _db.classGroupDao.getClassGroups();
    final result = <ClassGroup>[];
    for (final group in groups) {
      final students = await _db.classGroupDao.getStudentsForGroup(group.id);
      result.add(
        ClassGroup(
          id: group.id,
          name: group.name,
          students: students
              .map((s) => Student(id: s.id, name: s.name, className: s.className))
              .toList(),
        ),
      );
    }
    return result;
  }

  @override
  Future<List<GradeSummary>> fetchGradesForStudent(int studentId) async {
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
  Future<List<ScheduleDay>> fetchSchedule(int teacherId) async {
    final lessons = await _db.scheduleDao.getTeacherSchedule(teacherId);
    final grouped = <String, List<Lesson>>{};
    for (final lesson in lessons) {
      grouped.putIfAbsent(lesson.day, () => []).add(
            Lesson(
              time: lesson.time,
              subject: '${lesson.subject} (${lesson.className})',
              teacher: lesson.className,
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
  Future<List<Contact>> fetchParents() async {
    final contacts = await _db.contactDao.getContactsByType('parent');
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

  @override
  Future<void> addGrade(int studentId, String subject, int value) async {
    await _db.gradeDao.insertGrade(
      GradesCompanion.insert(
        studentId: studentId,
        subject: subject,
        value: value,
        createdAt: DateTime.now(),
      ),
    );
  }
}
