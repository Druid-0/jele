class Contact {
  final String name;
  final String role;
  final String phone;
  final String whatsapp;
  final String telegram;
  final String? subject;

  const Contact({
    required this.name,
    required this.role,
    required this.phone,
    required this.whatsapp,
    required this.telegram,
    this.subject,
  });
}
