import 'dart:math';

import 'package:collection/collection.dart';

import '../../domain/models/class_group.dart';
import '../../domain/models/contact_models.dart';
import '../../domain/models/grade_models.dart';
import '../../domain/models/schedule_models.dart';
import '../../domain/models/student_profile.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/school_repository.dart';
import '../local/app_database.dart';
import '../local/school_local_data_source.dart';
import '../remote/school_remote_data_source.dart';

class DriftSchoolRepository implements SchoolRepository {
  DriftSchoolRepository(
    this._local, {
    SchoolRemoteDataSource? remote,
    bool enableRemote = false,
  })  : _remote = remote,
        _enableRemote = enableRemote;

  final SchoolLocalDataSource _local;
  final SchoolRemoteDataSource? _remote;
  final bool _enableRemote;

  static const _weekdayNames = [
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
    'Воскресенье',
  ];

  @override
  Future<UserProfile?> authenticate({
    required String email,
    required String password,
  }) async {
    if (_enableRemote && _remote != null) {
      final remoteUser = await _remote!.authenticate(email: email, password: password);
      if (remoteUser != null) {
        return remoteUser;
      }
    }
    final user = await _local.fetchUserByEmailAndPassword(email, password);
    return user == null ? null : _mapUser(user);
  }

  @override
  Future<UserProfile?> fetchUserById(String id) async {
    if (_enableRemote && _remote != null) {
      final remoteUser = await _remote!.fetchUserById(id);
      if (remoteUser != null) {
        return remoteUser;
      }
    }
    final user = await _local.fetchUserById(id);
    return user == null ? null : _mapUser(user);
  }

  @override
  Future<List<StudentProfile>> fetchChildrenForParent(String parentId) async {
    if (_enableRemote && _remote != null) {
      final remoteChildren = await _remote!.fetchChildrenForParent(parentId);
      if (remoteChildren.isNotEmpty) {
        return remoteChildren;
      }
    }
    final rows = await _local.fetchChildrenForParent(parentId);
    return rows
        .map((row) => StudentProfile(
              id: row.id,
              name: row.name,
              className: row.className,
            ))
        .toList();
  }

  @override
  Future<StudentProfile?> fetchStudentById(String studentId) async {
    if (_enableRemote && _remote != null) {
      final remoteStudent = await _remote!.fetchStudentById(studentId);
      if (remoteStudent != null) {
        return remoteStudent;
      }
    }
    final row = await _local.fetchStudentById(studentId);
    if (row == null) {
      return null;
    }
    return StudentProfile(id: row.id, name: row.name, className: row.className);
  }

  @override
  Future<List<GradeSummary>> fetchGradesForStudent(String studentId) async {
    if (_enableRemote && _remote != null) {
      final remoteGrades = await _remote!.fetchGradesForStudent(studentId);
      if (remoteGrades.isNotEmpty) {
        return remoteGrades;
      }
    }
    final grades = await _local.fetchGradesForStudent(studentId);
    final subjects = await _local.fetchSubjects();
    final subjectMap = {for (final s in subjects) s.id: s.name};

    final grouped = groupBy(grades, (Grade grade) => grade.subjectId);

    return grouped.entries
        .map((entry) {
          final values = entry.value.map((g) => g.value).toList();
          final average = values.isEmpty
              ? 0
              : values.reduce((sum, value) => sum + value) / values.length;
          return GradeSummary(
            subject: subjectMap[entry.key] ?? entry.key,
            average: average,
            grades: values,
          );
        })
        .sorted((a, b) => b.average.compareTo(a.average));
  }

  @override
  Future<List<ScheduleDay>> fetchScheduleForStudent(String studentId) {
    if (_enableRemote && _remote != null) {
      return _remote!.fetchScheduleForStudent(studentId);
    }
    return _fetchSchedule(ownerType: 'student', ownerId: studentId);
  }

  @override
  Future<List<ScheduleDay>> fetchScheduleForTeacher(String teacherId) {
    if (_enableRemote && _remote != null) {
      return _remote!.fetchScheduleForTeacher(teacherId);
    }
    return _fetchSchedule(ownerType: 'teacher', ownerId: teacherId);
  }

  Future<List<ScheduleDay>> _fetchSchedule({required String ownerType, required String ownerId}) async {
    final lessons = await _local.fetchLessonsForOwner(ownerType, ownerId);
    final grouped = groupBy(lessons, (Lesson lesson) => lesson.dayOfWeek);

    return grouped.entries
        .map((entry) {
          final dayIndex = entry.key - 1;
          return ScheduleDay(
            day: _weekdayNames[dayIndex.clamp(0, _weekdayNames.length - 1)],
            lessons: entry.value
                .map((lesson) => Lesson(
                      time: '${lesson.startTime} - ${lesson.endTime}',
                      subject: lesson.subject,
                      teacher: lesson.teacherName,
                      room: lesson.room,
                    ))
                .toList(),
          );
        })
        .sorted((a, b) => _weekdayNames.indexOf(a.day).compareTo(_weekdayNames.indexOf(b.day)));
  }

  @override
  Future<List<TeacherContact>> fetchTeacherContactsForStudent(String studentId) async {
    if (_enableRemote && _remote != null) {
      final remoteContacts = await _remote!.fetchTeacherContactsForStudent(studentId);
      if (remoteContacts.isNotEmpty) {
        return remoteContacts;
      }
    }
    final rows = await _local.fetchTeacherContacts(studentId);
    return rows
        .map((row) => TeacherContact(
              name: row.name,
              subject: row.subject,
              phone: row.phone,
              whatsapp: row.whatsapp,
              telegram: row.telegram,
            ))
        .toList();
  }

  @override
  Future<List<ParentContact>> fetchParentContactsForTeacher(String teacherId) async {
    if (_enableRemote && _remote != null) {
      final remoteContacts = await _remote!.fetchParentContactsForTeacher(teacherId);
      if (remoteContacts.isNotEmpty) {
        return remoteContacts;
      }
    }
    final rows = await _local.fetchParentContacts(teacherId);
    return rows
        .map((row) => ParentContact(
              name: row.name,
              role: row.role,
              phone: row.phone,
              whatsapp: row.whatsapp,
              telegram: row.telegram,
            ))
        .toList();
  }

  @override
  Future<List<ClassGroup>> fetchClassGroupsForTeacher(String teacherId) async {
    if (_enableRemote && _remote != null) {
      final remoteGroups = await _remote!.fetchClassGroupsForTeacher(teacherId);
      if (remoteGroups.isNotEmpty) {
        return remoteGroups;
      }
    }
    final groups = await _local.fetchClassGroups(teacherId);
    final result = <ClassGroup>[];
    for (final group in groups) {
      final students = await _local.fetchStudentsForClassGroup(group.id);
      result.add(
        ClassGroup(
          id: group.id,
          name: group.name,
          students: students
              .map((s) => StudentProfile(
                    id: s.id,
                    name: s.name,
                    className: s.className,
                  ))
              .toList(),
        ),
      );
    }
    return result;
  }

  @override
  Future<void> addGrade({
    required String studentId,
    required String subject,
    required int value,
  }) async {
    if (_enableRemote && _remote != null) {
      await _remote!.addGrade(studentId: studentId, subject: subject, value: value);
    }
    final subjects = await _local.fetchSubjects();
    final subjectRow = subjects.firstWhereOrNull((s) => s.name == subject);
    final subjectId = subjectRow?.id ?? 'math';

    final id = 'g_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(99)}';
    await _local.insertGrade(
      GradesCompanion.insert(
        id: id,
        studentId: studentId,
        subjectId: subjectId,
        value: value,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> seedIfNeeded() => _local.seedDemoData();

  UserProfile _mapUser(User user) {
    return UserProfile(
      id: user.id,
      name: user.name,
      email: user.email,
      role: UserRoleX.fromKey(user.role),
      linkedStudentId: user.linkedStudentId,
    );
  }
}
