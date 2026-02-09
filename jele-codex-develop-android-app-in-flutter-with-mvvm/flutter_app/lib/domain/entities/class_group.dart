import 'student.dart';

class ClassGroup {
  final int id;
  final String name;
  final List<Student> students;

  const ClassGroup({
    required this.id,
    required this.name,
    required this.students,
  });
}
