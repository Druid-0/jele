class Lesson {
  final String time;
  final String subject;
  final String teacher;
  final String room;

  const Lesson({
    required this.time,
    required this.subject,
    required this.teacher,
    required this.room,
  });
}

class ScheduleDay {
  final String day;
  final List<Lesson> lessons;

  const ScheduleDay({required this.day, required this.lessons});
}
