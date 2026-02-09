import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/class_group_dao.dart';
import 'daos/contact_dao.dart';
import 'daos/grade_dao.dart';
import 'daos/parent_child_dao.dart';
import 'daos/schedule_dao.dart';
import 'daos/student_dao.dart';
import 'daos/teacher_dao.dart';
import 'daos/user_dao.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Students,
    Teachers,
    ClassGroups,
    ClassGroupStudents,
    ParentChildren,
    Grades,
    StudentSchedules,
    TeacherSchedules,
    Contacts,
  ],
  daos: [
    UserDao,
    StudentDao,
    TeacherDao,
    ClassGroupDao,
    ParentChildDao,
    GradeDao,
    ScheduleDao,
    ContactDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'edu_platform.sqlite'));
    return NativeDatabase(file);
  });
}
