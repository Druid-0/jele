import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'schedule_dao.g.dart';

@DriftAccessor(tables: [StudentSchedules, TeacherSchedules])
class ScheduleDao extends DatabaseAccessor<AppDatabase> with _$ScheduleDaoMixin {
  ScheduleDao(AppDatabase db) : super(db);

  Future<List<StudentSchedule>> getStudentSchedule(int studentId) {
    return (select(studentSchedules)..where((s) => s.studentId.equals(studentId))).get();
  }

  Future<List<TeacherSchedule>> getTeacherSchedule(int teacherId) {
    return (select(teacherSchedules)..where((s) => s.teacherId.equals(teacherId))).get();
  }

  Future<int> insertStudentSchedule(StudentSchedulesCompanion entry) =>
      into(studentSchedules).insert(entry);

  Future<int> insertTeacherSchedule(TeacherSchedulesCompanion entry) =>
      into(teacherSchedules).insert(entry);
}
