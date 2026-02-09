class GradeEntry {
  final int value;
  final DateTime date;

  const GradeEntry({required this.value, required this.date});
}

class GradeSummary {
  final String subject;
  final double average;
  final List<int> grades;

  const GradeSummary({
    required this.subject,
    required this.average,
    required this.grades,
  });
}
