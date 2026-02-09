import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'student_dao.g.dart';

@DriftAccessor(tables: [Students])
class StudentDao extends DatabaseAccessor<AppDatabase> with _$StudentDaoMixin {
  StudentDao(AppDatabase db) : super(db);

  Future<List<Student>> getStudentsByIds(List<int> ids) {
    return (select(students)..where((s) => s.id.isIn(ids))).get();
  }

  Future<Student?> getStudentById(int id) {
    return (select(students)..where((s) => s.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertStudent(StudentsCompanion entry) => into(students).insert(entry);
}
