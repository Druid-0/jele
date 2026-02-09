import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/models/class_group.dart';
import '../../domain/models/contact_models.dart';
import '../../domain/models/grade_models.dart';
import '../../domain/models/schedule_models.dart';
import '../../domain/models/student_profile.dart';
import '../../domain/models/user_profile.dart';

class SchoolRemoteDataSource {
  SchoolRemoteDataSource({required String baseUrl, http.Client? client})
      : _baseUrl = baseUrl,
        _client = client ?? http.Client();

  final String _baseUrl;
  final http.Client _client;

  Future<UserProfile?> authenticate({required String email, required String password}) async {
    final response = await _post('/auth/login', {
      'email': email,
      'password': password,
    });
    if (response == null) return null;
    return _mapUser(response);
  }

  Future<UserProfile?> fetchUserById(String id) async {
    final response = await _get('/users/$id');
    return response == null ? null : _mapUser(response);
  }

  Future<List<StudentProfile>> fetchChildrenForParent(String parentId) async {
    final response = await _get('/parents/$parentId/children');
    if (response == null) return [];
    final items = response['items'] as List<dynamic>? ?? [];
    return items.map((item) => _mapStudent(item as Map<String, dynamic>)).toList();
  }

  Future<StudentProfile?> fetchStudentById(String studentId) async {
    final response = await _get('/students/$studentId');
    return response == null ? null : _mapStudent(response);
  }

  Future<List<GradeSummary>> fetchGradesForStudent(String studentId) async {
    final response = await _get('/students/$studentId/grades');
    if (response == null) return [];
    final items = response['items'] as List<dynamic>? ?? [];
    return items.map((item) => _mapGradeSummary(item as Map<String, dynamic>)).toList();
  }

  Future<List<ScheduleDay>> fetchScheduleForStudent(String studentId) async {
    final response = await _get('/students/$studentId/schedule');
    if (response == null) return [];
    return _mapSchedule(response);
  }

  Future<List<ScheduleDay>> fetchScheduleForTeacher(String teacherId) async {
    final response = await _get('/teachers/$teacherId/schedule');
    if (response == null) return [];
    return _mapSchedule(response);
  }

  Future<List<TeacherContact>> fetchTeacherContactsForStudent(String studentId) async {
    final response = await _get('/students/$studentId/teachers');
    if (response == null) return [];
    final items = response['items'] as List<dynamic>? ?? [];
    return items.map((item) => _mapTeacher(item as Map<String, dynamic>)).toList();
  }

  Future<List<ParentContact>> fetchParentContactsForTeacher(String teacherId) async {
    final response = await _get('/teachers/$teacherId/parents');
    if (response == null) return [];
    final items = response['items'] as List<dynamic>? ?? [];
    return items.map((item) => _mapParent(item as Map<String, dynamic>)).toList();
  }

  Future<List<ClassGroup>> fetchClassGroupsForTeacher(String teacherId) async {
    final response = await _get('/teachers/$teacherId/classes');
    if (response == null) return [];
    final items = response['items'] as List<dynamic>? ?? [];
    return items.map((item) => _mapClassGroup(item as Map<String, dynamic>)).toList();
  }

  Future<void> addGrade({required String studentId, required String subject, required int value}) async {
    await _post('/students/$studentId/grades', {
      'subject': subject,
      'value': value,
    });
  }

  Future<Map<String, dynamic>?> _get(String path) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await _client.get(uri, headers: _headers());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  Future<Map<String, dynamic>?> _post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await _client.post(uri, headers: _headers(), body: jsonEncode(body));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  Map<String, String> _headers() => {'Content-Type': 'application/json'};

  UserProfile _mapUser(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRoleX.fromKey(json['role'] as String),
      linkedStudentId: json['linkedStudentId'] as String?,
    );
  }

  StudentProfile _mapStudent(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      className: json['className'] as String,
    );
  }

  GradeSummary _mapGradeSummary(Map<String, dynamic> json) {
    return GradeSummary(
      subject: json['subject'] as String,
      average: (json['average'] as num).toDouble(),
      grades: (json['grades'] as List<dynamic>).map((value) => value as int).toList(),
    );
  }

  List<ScheduleDay> _mapSchedule(Map<String, dynamic> json) {
    final items = json['items'] as List<dynamic>? ?? [];
    return items.map((item) {
      final day = item as Map<String, dynamic>;
      final lessons = (day['lessons'] as List<dynamic>? ?? [])
          .map((lesson) => _mapLesson(lesson as Map<String, dynamic>))
          .toList();
      return ScheduleDay(day: day['day'] as String, lessons: lessons);
    }).toList();
  }

  Lesson _mapLesson(Map<String, dynamic> json) {
    return Lesson(
      time: json['time'] as String,
      subject: json['subject'] as String,
      teacher: json['teacher'] as String,
      room: json['room'] as String,
    );
  }

  TeacherContact _mapTeacher(Map<String, dynamic> json) {
    return TeacherContact(
      name: json['name'] as String,
      subject: json['subject'] as String,
      phone: json['phone'] as String,
      whatsapp: json['whatsapp'] as String,
      telegram: json['telegram'] as String,
    );
  }

  ParentContact _mapParent(Map<String, dynamic> json) {
    return ParentContact(
      name: json['name'] as String,
      role: json['role'] as String,
      phone: json['phone'] as String,
      whatsapp: json['whatsapp'] as String,
      telegram: json['telegram'] as String,
    );
  }

  ClassGroup _mapClassGroup(Map<String, dynamic> json) {
    final students = (json['students'] as List<dynamic>? ?? [])
        .map((student) => _mapStudent(student as Map<String, dynamic>))
        .toList();
    return ClassGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      students: students,
    );
  }
}
