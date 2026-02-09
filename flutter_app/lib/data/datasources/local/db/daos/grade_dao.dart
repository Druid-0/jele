import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'grade_dao.g.dart';

@DriftAccessor(tables: [Grades])
class GradeDao extends DatabaseAccessor<AppDatabase> with _$GradeDaoMixin {
  GradeDao(AppDatabase db) : super(db);

  Future<List<Grade>> getGradesForStudent(int studentId) {
    return (select(grades)..where((g) => g.studentId.equals(studentId))).get();
  }

  Future<int> insertGrade(GradesCompanion entry) => into(grades).insert(entry);
}
