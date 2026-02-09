enum UserRole { parent, teacher, student }

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.parent:
        return 'Родитель';
      case UserRole.teacher:
        return 'Преподаватель';
      case UserRole.student:
        return 'Ученик';
    }
  }

  String get storageKey {
    return name;
  }

  static UserRole fromKey(String key) {
    return UserRole.values.firstWhere((role) => role.name == key);
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? linkedStudentId;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.linkedStudentId,
  });
}
