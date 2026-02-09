import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'class_group_dao.g.dart';

@DriftAccessor(tables: [ClassGroups, ClassGroupStudents, Students])
class ClassGroupDao extends DatabaseAccessor<AppDatabase> with _$ClassGroupDaoMixin {
  ClassGroupDao(AppDatabase db) : super(db);

  Future<List<ClassGroup>> getClassGroups() => select(classGroups).get();

  Future<List<Student>> getStudentsForGroup(int groupId) {
    final query = select(students).join([
      innerJoin(classGroupStudents, classGroupStudents.studentId.equalsExp(students.id)),
    ])..where(classGroupStudents.classGroupId.equals(groupId));

    return query.map((row) => row.readTable(students)).get();
  }

  Future<int> insertClassGroup(ClassGroupsCompanion entry) => into(classGroups).insert(entry);

  Future<int> insertClassGroupStudent(ClassGroupStudentsCompanion entry) =>
      into(classGroupStudents).insert(entry);
}
