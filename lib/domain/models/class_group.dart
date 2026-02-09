import 'student_profile.dart';

class ClassGroup {
  final String id;
  final String name;
  final List<StudentProfile> students;

  const ClassGroup({
    required this.id,
    required this.name,
    required this.students,
  });
}
