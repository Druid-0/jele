import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'teacher_dao.g.dart';

@DriftAccessor(tables: [Teachers])
class TeacherDao extends DatabaseAccessor<AppDatabase> with _$TeacherDaoMixin {
  TeacherDao(AppDatabase db) : super(db);

  Future<Teacher?> getTeacherById(int id) {
    return (select(teachers)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<Teacher>> getAllTeachers() => select(teachers).get();

  Future<int> insertTeacher(TeachersCompanion entry) => into(teachers).insert(entry);
}
