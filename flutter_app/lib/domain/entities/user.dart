enum UserRole { parent, teacher, student }

class User {
  final int id;
  final String email;
  final UserRole role;
  final int? profileId;

  const User({
    required this.id,
    required this.email,
    required this.role,
    this.profileId,
  });
}
