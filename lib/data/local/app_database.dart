import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/school_dao.dart';

part 'app_database.g.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get password => text()();
  TextColumn get role => text()();
  TextColumn get linkedStudentId => text().nullable()();

  @override
  Set<TextColumn> get primaryKey => {id};
}

class Students extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get className => text()();
  TextColumn get parentUserId => text()();
  TextColumn get teacherUserId => text()();

  @override
  Set<TextColumn> get primaryKey => {id};
}

class Subjects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  @override
  Set<TextColumn> get primaryKey => {id};
}

class Grades extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get subjectId => text()();
  IntColumn get value => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<TextColumn> get primaryKey => {id};
}

class Lessons extends Table {
  TextColumn get id => text()();
  TextColumn get ownerType => text()();
  TextColumn get ownerId => text()();
  IntColumn get dayOfWeek => integer()();
  TextColumn get startTime => text()();
  TextColumn get endTime => text()();
  TextColumn get subject => text()();
  TextColumn get teacherName => text()();
  TextColumn get room => text()();

  @override
  Set<TextColumn> get primaryKey => {id};
}

class TeacherContacts extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get name => text()();
  TextColumn get subject => text()();
  TextColumn get phone => text()();
  TextColumn get whatsapp => text()();
  TextColumn get telegram => text()();

  @override
  Set<TextColumn> get primaryKey => {id};
}

class ParentContacts extends Table {
  TextColumn get id => text()();
  TextColumn get teacherUserId => text()();
  TextColumn get name => text()();
  TextColumn get role => text()();
  TextColumn get phone => text()();
  TextColumn get whatsapp => text()();
  TextColumn get telegram => text()();

  @override
  Set<TextColumn> get primaryKey => {id};
}

class ClassGroups extends Table {
  TextColumn get id => text()();
  TextColumn get teacherUserId => text()();
  TextColumn get name => text()();

  @override
  Set<TextColumn> get primaryKey => {id};
}

class ClassStudents extends Table {
  TextColumn get id => text()();
  TextColumn get classGroupId => text()();
  TextColumn get studentId => text()();

  @override
  Set<TextColumn> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Users,
    Students,
    Subjects,
    Grades,
    Lessons,
    TeacherContacts,
    ParentContacts,
    ClassGroups,
    ClassStudents,
  ],
  daos: [SchoolDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  late final SchoolDao schoolDao = SchoolDao(this);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
        },
        onUpgrade: (migrator, from, to) async {
          await migrator.createAll();
        },
      );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'greeting_message');
}
