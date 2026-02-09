import 'package:drift/drift.dart';
import '../../domain/models/user_profile.dart';
import 'app_database.dart';
import 'daos/school_dao.dart';

class SchoolLocalDataSource {
  final SchoolDao _dao;

  SchoolLocalDataSource(AppDatabase database) : _dao = database.schoolDao;

  Future<User?> fetchUserByEmailAndPassword(String email, String password) {
    return _dao.fetchUserByEmailAndPassword(email, password);
  }

  Future<User?> fetchUserById(String id) => _dao.fetchUserById(id);

  Future<List<Student>> fetchChildrenForParent(String parentId) {
    return _dao.fetchChildrenForParent(parentId);
  }

  Future<Student?> fetchStudentById(String studentId) => _dao.fetchStudentById(studentId);

  Future<List<Grade>> fetchGradesForStudent(String studentId) => _dao.fetchGradesForStudent(studentId);

  Future<List<Subject>> fetchSubjects() => _dao.fetchSubjects();

  Future<List<Lesson>> fetchLessonsForOwner(String ownerType, String ownerId) {
    return _dao.fetchLessonsForOwner(ownerType, ownerId);
  }

  Future<List<TeacherContact>> fetchTeacherContacts(String studentId) {
    return _dao.fetchTeacherContacts(studentId);
  }

  Future<List<ParentContact>> fetchParentContacts(String teacherId) {
    return _dao.fetchParentContacts(teacherId);
  }

  Future<List<ClassGroup>> fetchClassGroups(String teacherId) {
    return _dao.fetchClassGroups(teacherId);
  }

  Future<List<Student>> fetchStudentsForClassGroup(String classGroupId) {
    return _dao.fetchStudentsForClassGroup(classGroupId);
  }

  Future<void> insertGrade(GradesCompanion entry) => _dao.insertGrade(entry);

  Future<void> seedDemoData() async {
    final hasUsers = await _dao.usersCount() > 0;
    if (hasUsers) {
      return;
    }

    await _dao.insertUser(
      UsersCompanion.insert(
        id: 'user_parent',
        name: 'Анна Смирнова',
        email: 'parent@edu.ru',
        password: 'password',
        role: UserRole.parent.storageKey,
        linkedStudentId: const Value(null),
      ),
    );

    await _dao.insertUser(
      UsersCompanion.insert(
        id: 'user_teacher',
        name: 'Ирина Кузнецова',
        email: 'teacher@edu.ru',
        password: 'password',
        role: UserRole.teacher.storageKey,
        linkedStudentId: const Value(null),
      ),
    );

    await _dao.insertUser(
      UsersCompanion.insert(
        id: 'user_student',
        name: 'Даниил Сафонов',
        email: 'student@edu.ru',
        password: 'password',
        role: UserRole.student.storageKey,
        linkedStudentId: const Value('student_1'),
      ),
    );

    await _dao.insertStudent(
      StudentsCompanion.insert(
        id: 'student_1',
        name: 'Даниил Сафонов',
        className: '7А',
        parentUserId: 'user_parent',
        teacherUserId: 'user_teacher',
      ),
    );

    await _dao.insertStudent(
      StudentsCompanion.insert(
        id: 'student_2',
        name: 'Мария Орлова',
        className: '7А',
        parentUserId: 'user_parent',
        teacherUserId: 'user_teacher',
      ),
    );

    await _dao.insertStudent(
      StudentsCompanion.insert(
        id: 'student_3',
        name: 'Сергей Петров',
        className: '8Б',
        parentUserId: 'user_parent',
        teacherUserId: 'user_teacher',
      ),
    );

    final subjectsData = [
      const {'id': 'math', 'name': 'Математика'},
      const {'id': 'history', 'name': 'История'},
      const {'id': 'physics', 'name': 'Физика'},
      const {'id': 'literature', 'name': 'Литература'},
    ];

    for (final subject in subjectsData) {
      await _dao.insertSubject(
        SubjectsCompanion.insert(
          id: subject['id']!,
          name: subject['name']!,
        ),
      );
    }

    final gradesData = <Map<String, dynamic>>[
      {'id': 'g1', 'student': 'student_1', 'subject': 'math', 'value': 5},
      {'id': 'g2', 'student': 'student_1', 'subject': 'math', 'value': 4},
      {'id': 'g3', 'student': 'student_1', 'subject': 'history', 'value': 5},
      {'id': 'g4', 'student': 'student_1', 'subject': 'physics', 'value': 4},
      {'id': 'g5', 'student': 'student_1', 'subject': 'literature', 'value': 5},
      {'id': 'g6', 'student': 'student_2', 'subject': 'math', 'value': 4},
      {'id': 'g7', 'student': 'student_2', 'subject': 'history', 'value': 3},
      {'id': 'g8', 'student': 'student_3', 'subject': 'math', 'value': 5},
    ];

    for (final entry in gradesData) {
      await _dao.insertGrade(
        GradesCompanion.insert(
          id: entry['id'] as String,
          studentId: entry['student'] as String,
          subjectId: entry['subject'] as String,
          value: entry['value'] as int,
          createdAt: DateTime.now(),
        ),
      );
    }

    final lessonsData = [
      {
        'id': 'l1',
        'ownerType': 'student',
        'ownerId': 'student_1',
        'day': 1,
        'start': '08:30',
        'end': '09:15',
        'subject': 'Математика',
        'teacher': 'Ирина Кузнецова',
        'room': '214',
      },
      {
        'id': 'l2',
        'ownerType': 'student',
        'ownerId': 'student_1',
        'day': 1,
        'start': '09:25',
        'end': '10:10',
        'subject': 'История',
        'teacher': 'Антон Воронцов',
        'room': '305',
      },
      {
        'id': 'l3',
        'ownerType': 'student',
        'ownerId': 'student_1',
        'day': 2,
        'start': '10:20',
        'end': '11:05',
        'subject': 'Литература',
        'teacher': 'Марина Волкова',
        'room': '110',
      },
      {
        'id': 'l4',
        'ownerType': 'teacher',
        'ownerId': 'user_teacher',
        'day': 1,
        'start': '08:30',
        'end': '09:15',
        'subject': 'Алгебра',
        'teacher': '7А',
        'room': '214',
      },
      {
        'id': 'l5',
        'ownerType': 'teacher',
        'ownerId': 'user_teacher',
        'day': 1,
        'start': '09:25',
        'end': '10:10',
        'subject': 'Геометрия',
        'teacher': '7Б',
        'room': '216',
      },
    ];

    for (final entry in lessonsData) {
      await _dao.insertLesson(
        LessonsCompanion.insert(
          id: entry['id'] as String,
          ownerType: entry['ownerType'] as String,
          ownerId: entry['ownerId'] as String,
          dayOfWeek: entry['day'] as int,
          startTime: entry['start'] as String,
          endTime: entry['end'] as String,
          subject: entry['subject'] as String,
          teacherName: entry['teacher'] as String,
          room: entry['room'] as String,
        ),
      );
    }

    await _dao.insertTeacherContact(
      TeacherContactsCompanion.insert(
        id: 't1',
        studentId: 'student_1',
        name: 'Марина Волкова',
        subject: 'Литература',
        phone: '+7 900 100-20-30',
        whatsapp: '+79001002030',
        telegram: '@volkova_m',
      ),
    );

    await _dao.insertTeacherContact(
      TeacherContactsCompanion.insert(
        id: 't2',
        studentId: 'student_1',
        name: 'Ирина Кузнецова',
        subject: 'Математика',
        phone: '+7 900 200-30-40',
        whatsapp: '+79002003040',
        telegram: '@math_teacher',
      ),
    );

    await _dao.insertParentContact(
      ParentContactsCompanion.insert(
        id: 'p1',
        teacherUserId: 'user_teacher',
        name: 'Анна Смирнова',
        role: 'Мама Даниила',
        phone: '+7 900 123-45-67',
        whatsapp: '+79001234567',
        telegram: '@anna_parent',
      ),
    );

    await _dao.insertParentContact(
      ParentContactsCompanion.insert(
        id: 'p2',
        teacherUserId: 'user_teacher',
        name: 'Елена Орлова',
        role: 'Мама Марии',
        phone: '+7 900 222-33-44',
        whatsapp: '+79002223344',
        telegram: '@elena_orlova',
      ),
    );

    await _dao.insertClassGroup(
      ClassGroupsCompanion.insert(
        id: 'class_7a',
        teacherUserId: 'user_teacher',
        name: '7А',
      ),
    );

    await _dao.insertClassGroup(
      ClassGroupsCompanion.insert(
        id: 'class_8b',
        teacherUserId: 'user_teacher',
        name: '8Б',
      ),
    );

    await _dao.insertClassStudent(
      ClassStudentsCompanion.insert(
        id: 'cs1',
        classGroupId: 'class_7a',
        studentId: 'student_1',
      ),
    );

    await _dao.insertClassStudent(
      ClassStudentsCompanion.insert(
        id: 'cs2',
        classGroupId: 'class_7a',
        studentId: 'student_2',
      ),
    );

    await _dao.insertClassStudent(
      ClassStudentsCompanion.insert(
        id: 'cs3',
        classGroupId: 'class_8b',
        studentId: 'student_3',
      ),
    );
  }
}
