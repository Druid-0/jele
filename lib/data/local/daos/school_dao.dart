import 'package:drift/drift.dart';
import '../app_database.dart';

part 'school_dao.g.dart';

@DriftAccessor(
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
)
class SchoolDao extends DatabaseAccessor<AppDatabase> with _$SchoolDaoMixin {
  SchoolDao(super.db);

  Future<User?> fetchUserByEmail(String email) {
    return (select(users)..where((tbl) => tbl.email.equals(email))).getSingleOrNull();
  }

  Future<User?> fetchUserByEmailAndPassword(String email, String password) {
    return (select(users)
          ..where((tbl) => tbl.email.equals(email))
          ..where((tbl) => tbl.password.equals(password)))
        .getSingleOrNull();
  }

  Future<User?> fetchUserById(String id) {
    return (select(users)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> usersCount() async {
    final row = await customSelect('SELECT COUNT(*) as count FROM users').getSingle();
    return row.data['count'] as int? ?? 0;
  }

  Future<List<Student>> fetchChildrenForParent(String parentId) {
    return (select(students)..where((tbl) => tbl.parentUserId.equals(parentId))).get();
  }

  Future<Student?> fetchStudentById(String studentId) {
    return (select(students)..where((tbl) => tbl.id.equals(studentId))).getSingleOrNull();
  }

  Future<List<Grade>> fetchGradesForStudent(String studentId) {
    return (select(grades)..where((tbl) => tbl.studentId.equals(studentId))).get();
  }

  Future<List<Subject>> fetchSubjects() {
    return select(subjects).get();
  }

  Future<List<Lesson>> fetchLessonsForOwner(String ownerType, String ownerId) {
    return (select(lessons)
          ..where((tbl) => tbl.ownerType.equals(ownerType))
          ..where((tbl) => tbl.ownerId.equals(ownerId))
          ..orderBy([
            (tbl) => OrderingTerm(expression: tbl.dayOfWeek),
            (tbl) => OrderingTerm(expression: tbl.startTime),
          ]))
        .get();
  }

  Future<List<TeacherContact>> fetchTeacherContacts(String studentId) {
    return (select(teacherContacts)
          ..where((tbl) => tbl.studentId.equals(studentId)))
        .get();
  }

  Future<List<ParentContact>> fetchParentContacts(String teacherId) {
    return (select(parentContacts)
          ..where((tbl) => tbl.teacherUserId.equals(teacherId)))
        .get();
  }

  Future<List<ClassGroup>> fetchClassGroups(String teacherId) {
    return (select(classGroups)..where((tbl) => tbl.teacherUserId.equals(teacherId))).get();
  }

  Future<List<Student>> fetchStudentsForClassGroup(String classGroupId) async {
    final query = select(students).join([
      innerJoin(classStudents, classStudents.studentId.equalsExp(students.id)),
    ])
      ..where(classStudents.classGroupId.equals(classGroupId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(students)).toList();
  }

  Future<void> insertGrade(GradesCompanion entry) {
    return into(grades).insert(entry, mode: InsertMode.insertOrReplace);
  }

  Future<void> insertUser(UsersCompanion entry) {
    return into(users).insert(entry, mode: InsertMode.insertOrReplace);
  }

  Future<void> insertStudent(StudentsCompanion entry) {
    return into(students).insert(entry, mode: InsertMode.insertOrReplace);
  }

  Future<void> insertSubject(SubjectsCompanion entry) {
    return into(subjects).insert(entry, mode: InsertMode.insertOrReplace);
  }

  Future<void> insertLesson(LessonsCompanion entry) {
    return into(lessons).insert(entry, mode: InsertMode.insertOrReplace);
  }

  Future<void> insertTeacherContact(TeacherContactsCompanion entry) {
    return into(teacherContacts).insert(entry, mode: InsertMode.insertOrReplace);
  }

  Future<void> insertParentContact(ParentContactsCompanion entry) {
    return into(parentContacts).insert(entry, mode: InsertMode.insertOrReplace);
  }

  Future<void> insertClassGroup(ClassGroupsCompanion entry) {
    return into(classGroups).insert(entry, mode: InsertMode.insertOrReplace);
  }

  Future<void> insertClassStudent(ClassStudentsCompanion entry) {
    return into(classStudents).insert(entry, mode: InsertMode.insertOrReplace);
  }
}
