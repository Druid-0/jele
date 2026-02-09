import 'package:drift/drift.dart';

import 'db/app_database.dart';
import 'db/tables.dart';

class SeedData {
  static Future<void> seed(AppDatabase db) async {
    final existing = await db.userDao.findByEmail('parent@demo.ru');
    if (existing != null) return;

    final parentId = await db.userDao.insertUser(
      UsersCompanion.insert(
        email: 'parent@demo.ru',
        passwordHash: 'password',
        role: 'parent',
      ),
    );

    final student1Id = await db.studentDao.insertStudent(
      StudentsCompanion.insert(name: 'Алексей Иванов', className: '8А'),
    );
    final student2Id = await db.studentDao.insertStudent(
      StudentsCompanion.insert(name: 'Мария Иванова', className: '6Б'),
    );

    await db.parentChildDao.insertParentChild(
      ParentChildrenCompanion.insert(parentUserId: parentId, studentId: student1Id),
    );
    await db.parentChildDao.insertParentChild(
      ParentChildrenCompanion.insert(parentUserId: parentId, studentId: student2Id),
    );

    final teacherId = await db.teacherDao.insertTeacher(
      TeachersCompanion.insert(name: 'Смирнова Анна Викторовна', subject: 'Математика'),
    );

    await db.userDao.insertUser(
      UsersCompanion.insert(
        email: 'teacher@demo.ru',
        passwordHash: 'password',
        role: 'teacher',
        profileId: Value(teacherId),
      ),
    );

    await db.userDao.insertUser(
      UsersCompanion.insert(
        email: 'student@demo.ru',
        passwordHash: 'password',
        role: 'student',
        profileId: Value(student1Id),
      ),
    );

    final class8aId = await db.classGroupDao.insertClassGroup(
      ClassGroupsCompanion.insert(name: '8А'),
    );
    final class8bId = await db.classGroupDao.insertClassGroup(
      ClassGroupsCompanion.insert(name: '8Б'),
    );

    final studentsFor8a = [
      StudentsCompanion.insert(name: 'Петр Сидоров', className: '8А'),
      StudentsCompanion.insert(name: 'Ольга Николаева', className: '8А'),
      StudentsCompanion.insert(name: 'Дмитрий Козлов', className: '8А'),
    ];

    final studentsFor8b = [
      StudentsCompanion.insert(name: 'Екатерина Морозова', className: '8Б'),
      StudentsCompanion.insert(name: 'Андрей Волков', className: '8Б'),
      StudentsCompanion.insert(name: 'Анна Федорова', className: '8Б'),
    ];

    final extraStudentsA = <int>[];
    for (final entry in studentsFor8a) {
      extraStudentsA.add(await db.studentDao.insertStudent(entry));
    }
    final extraStudentsB = <int>[];
    for (final entry in studentsFor8b) {
      extraStudentsB.add(await db.studentDao.insertStudent(entry));
    }

    await db.classGroupDao.insertClassGroupStudent(
      ClassGroupStudentsCompanion.insert(classGroupId: class8aId, studentId: student1Id),
    );

    for (final studentId in extraStudentsA) {
      await db.classGroupDao.insertClassGroupStudent(
        ClassGroupStudentsCompanion.insert(classGroupId: class8aId, studentId: studentId),
      );
    }

    for (final studentId in extraStudentsB) {
      await db.classGroupDao.insertClassGroupStudent(
        ClassGroupStudentsCompanion.insert(classGroupId: class8bId, studentId: studentId),
      );
    }

    await _seedGrades(db, student1Id, student2Id, extraStudentsA, extraStudentsB);
    await _seedStudentSchedules(db, student1Id, student2Id);
    await _seedTeacherSchedule(db, teacherId);
    await _seedContacts(db);
  }

  static Future<void> _seedGrades(
    AppDatabase db,
    int student1Id,
    int student2Id,
    List<int> extraStudentsA,
    List<int> extraStudentsB,
  ) async {
    final now = DateTime.now();
    final gradesStudent1 = {
      'Математика': [5, 4, 5, 5, 4],
      'Русский язык': [4, 4, 5, 4],
      'Физика': [5, 5, 5, 4],
      'Английский язык': [4, 5, 4, 5],
      'История': [5, 4, 4, 5],
      'Информатика': [5, 5, 5, 5],
    };

    final gradesStudent2 = {
      'Математика': [5, 5, 4, 5],
      'Русский язык': [5, 4, 5, 5],
      'Биология': [4, 4, 5, 4],
      'Английский язык': [5, 5, 5, 4],
      'География': [4, 5, 4, 4],
    };

    await _insertGrades(db, student1Id, gradesStudent1, now);
    await _insertGrades(db, student2Id, gradesStudent2, now);

    for (final studentId in [...extraStudentsA, ...extraStudentsB]) {
      await _insertGrades(db, studentId, {'Математика': [5, 4, 4, 3]}, now);
    }
  }

  static Future<void> _insertGrades(
    AppDatabase db,
    int studentId,
    Map<String, List<int>> grades,
    DateTime now,
  ) async {
    for (final entry in grades.entries) {
      for (final value in entry.value) {
        await db.gradeDao.insertGrade(
          GradesCompanion.insert(
            studentId: studentId,
            subject: entry.key,
            value: value,
            createdAt: now,
          ),
        );
      }
    }
  }

  static Future<void> _seedStudentSchedules(
    AppDatabase db,
    int student1Id,
    int student2Id,
  ) async {
    final scheduleStudent1 = [
      {
        'day': 'Понедельник',
        'lessons': [
          {'time': '08:00 - 08:45', 'subject': 'Математика', 'teacher': 'Смирнова А.В.', 'room': '201'},
          {'time': '09:00 - 09:45', 'subject': 'Русский язык', 'teacher': 'Петров И.С.', 'room': '105'},
          {'time': '10:00 - 10:45', 'subject': 'Физика', 'teacher': 'Кузнецова М.П.', 'room': '304'},
          {'time': '11:00 - 11:45', 'subject': 'Английский язык', 'teacher': 'Соколова Е.А.', 'room': '210'},
        ]
      },
      {
        'day': 'Вторник',
        'lessons': [
          {'time': '08:00 - 08:45', 'subject': 'История', 'teacher': 'Николаев В.И.', 'room': '108'},
          {'time': '09:00 - 09:45', 'subject': 'Информатика', 'teacher': 'Федоров Д.М.', 'room': '401'},
          {'time': '10:00 - 10:45', 'subject': 'Математика', 'teacher': 'Смирнова А.В.', 'room': '201'},
          {'time': '11:00 - 11:45', 'subject': 'Физика', 'teacher': 'Кузнецова М.П.', 'room': '304'},
        ]
      },
    ];

    final scheduleStudent2 = [
      {
        'day': 'Понедельник',
        'lessons': [
          {'time': '08:00 - 08:45', 'subject': 'Математика', 'teacher': 'Смирнова А.В.', 'room': '201'},
          {'time': '09:00 - 09:45', 'subject': 'Русский язык', 'teacher': 'Петров И.С.', 'room': '105'},
          {'time': '10:00 - 10:45', 'subject': 'Биология', 'teacher': 'Морозова Т.В.', 'room': '203'},
          {'time': '11:00 - 11:45', 'subject': 'Английский язык', 'teacher': 'Соколова Е.А.', 'room': '210'},
        ]
      },
      {
        'day': 'Вторник',
        'lessons': [
          {'time': '08:00 - 08:45', 'subject': 'География', 'teacher': 'Волков С.Н.', 'room': '107'},
          {'time': '09:00 - 09:45', 'subject': 'Математика', 'teacher': 'Смирнова А.В.', 'room': '201'},
          {'time': '10:00 - 10:45', 'subject': 'Русский язык', 'teacher': 'Петров И.С.', 'room': '105'},
          {'time': '11:00 - 11:45', 'subject': 'Английский язык', 'teacher': 'Соколова Е.А.', 'room': '210'},
        ]
      },
    ];

    await _insertSchedule(db, student1Id, scheduleStudent1);
    await _insertSchedule(db, student2Id, scheduleStudent2);
  }

  static Future<void> _insertSchedule(
    AppDatabase db,
    int studentId,
    List<Map<String, dynamic>> schedule,
  ) async {
    for (final day in schedule) {
      final lessons = day['lessons'] as List<Map<String, String>>;
      for (final lesson in lessons) {
        await db.scheduleDao.insertStudentSchedule(
          StudentSchedulesCompanion.insert(
            studentId: studentId,
            day: day['day'] as String,
            time: lesson['time']!,
            subject: lesson['subject']!,
            teacher: lesson['teacher']!,
            room: lesson['room']!,
          ),
        );
      }
    }
  }

  static Future<void> _seedTeacherSchedule(AppDatabase db, int teacherId) async {
    final schedule = [
      {
        'day': 'Понедельник',
        'lessons': [
          {'time': '08:00 - 08:45', 'subject': 'Математика', 'class': '8А', 'room': '201'},
          {'time': '09:00 - 09:45', 'subject': 'Математика', 'class': '6Б', 'room': '201'},
          {'time': '10:00 - 10:45', 'subject': 'Математика', 'class': '8Б', 'room': '201'},
        ]
      },
      {
        'day': 'Вторник',
        'lessons': [
          {'time': '09:00 - 09:45', 'subject': 'Математика', 'class': '6А', 'room': '201'},
          {'time': '10:00 - 10:45', 'subject': 'Математика', 'class': '8А', 'room': '201'},
          {'time': '11:00 - 11:45', 'subject': 'Математика', 'class': '8Б', 'room': '201'},
        ]
      },
      {
        'day': 'Среда',
        'lessons': [
          {'time': '08:00 - 08:45', 'subject': 'Математика', 'class': '8А', 'room': '201'},
          {'time': '09:00 - 09:45', 'subject': 'Математика', 'class': '6Б', 'room': '201'},
        ]
      },
    ];

    for (final day in schedule) {
      final lessons = day['lessons'] as List<Map<String, String>>;
      for (final lesson in lessons) {
        await db.scheduleDao.insertTeacherSchedule(
          TeacherSchedulesCompanion.insert(
            teacherId: teacherId,
            day: day['day'] as String,
            time: lesson['time']!,
            subject: lesson['subject']!,
            className: lesson['class']!,
            room: lesson['room']!,
          ),
        );
      }
    }
  }

  static Future<void> _seedContacts(AppDatabase db) async {
    final teachers = [
      {
        'name': 'Смирнова Анна Викторовна',
        'role': 'Преподаватель',
        'subject': 'Математика',
        'phone': '+7 (999) 123-45-67',
        'whatsapp': '+79991234567',
        'telegram': '@smirnova_av',
        'type': 'teacher',
      },
      {
        'name': 'Петров Иван Сергеевич',
        'role': 'Преподаватель',
        'subject': 'Русский язык',
        'phone': '+7 (999) 234-56-78',
        'whatsapp': '+79992345678',
        'telegram': '@petrov_is',
        'type': 'teacher',
      },
      {
        'name': 'Кузнецова Мария Павловна',
        'role': 'Преподаватель',
        'subject': 'Физика',
        'phone': '+7 (999) 345-67-89',
        'whatsapp': '+79993456789',
        'telegram': '@kuznetsova_mp',
        'type': 'teacher',
      },
      {
        'name': 'Соколова Елена Андреевна',
        'role': 'Преподаватель',
        'subject': 'Английский язык',
        'phone': '+7 (999) 456-78-90',
        'whatsapp': '+79994567890',
        'telegram': '@sokolova_ea',
        'type': 'teacher',
      },
    ];

    final parents = [
      {
        'name': 'Иванов Сергей Петрович',
        'role': 'Родитель',
        'phone': '+7 (999) 111-22-33',
        'whatsapp': '+79991112233',
        'telegram': '@ivanov_sp',
        'type': 'parent',
      },
      {
        'name': 'Сидорова Татьяна Ивановна',
        'role': 'Родитель',
        'phone': '+7 (999) 222-33-44',
        'whatsapp': '+79992223344',
        'telegram': '@sidorova_ti',
        'type': 'parent',
      },
      {
        'name': 'Николаев Александр Дмитриевич',
        'role': 'Родитель',
        'phone': '+7 (999) 333-44-55',
        'whatsapp': '+79993334455',
        'telegram': '@nikolaev_ad',
        'type': 'parent',
      },
    ];

    for (final entry in [...teachers, ...parents]) {
      await db.contactDao.insertContact(
        ContactsCompanion.insert(
          name: entry['name']!,
          role: entry['role']!,
          phone: entry['phone']!,
          whatsapp: entry['whatsapp']!,
          telegram: entry['telegram']!,
          subject: Value(entry['subject']),
          type: entry['type']!,
        ),
      );
    }
  }
}
