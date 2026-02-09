import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().withLength(min: 5, max: 120)();
  TextColumn get passwordHash => text()();
  TextColumn get role => text()();
  IntColumn get profileId => integer().nullable()();
}

class Students extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get className => text()();
}

class Teachers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get subject => text()();
}

class ClassGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class ClassGroupStudents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get classGroupId => integer().references(ClassGroups, #id)();
  IntColumn get studentId => integer().references(Students, #id)();
}

class ParentChildren extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get parentUserId => integer().references(Users, #id)();
  IntColumn get studentId => integer().references(Students, #id)();
}

class Grades extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer().references(Students, #id)();
  TextColumn get subject => text()();
  IntColumn get value => integer()();
  DateTimeColumn get createdAt => dateTime()();
}

class StudentSchedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer().references(Students, #id)();
  TextColumn get day => text()();
  TextColumn get time => text()();
  TextColumn get subject => text()();
  TextColumn get teacher => text()();
  TextColumn get room => text()();
}

class TeacherSchedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get teacherId => integer().references(Teachers, #id)();
  TextColumn get day => text()();
  TextColumn get time => text()();
  TextColumn get subject => text()();
  TextColumn get className => text()();
  TextColumn get room => text()();
}

class Contacts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get role => text()();
  TextColumn get phone => text()();
  TextColumn get whatsapp => text()();
  TextColumn get telegram => text()();
  TextColumn get subject => text().nullable()();
  TextColumn get type => text()();
}
