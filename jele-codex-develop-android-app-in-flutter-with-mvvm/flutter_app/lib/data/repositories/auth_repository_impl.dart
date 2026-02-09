import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/db/app_database.dart';
import '../datasources/local/seed_data.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AppDatabase _db;

  AuthRepositoryImpl(this._db);

  @override
  Future<User> login(String email, String password) async {
    await SeedData.seed(_db);
    final user = await _db.userDao.findByEmail(email);
    if (user == null || user.passwordHash != password) {
      throw Exception('Неверный email или пароль');
    }

    return User(
      id: user.id,
      email: user.email,
      role: _parseRole(user.role),
      profileId: user.profileId,
    );
  }

  UserRole _parseRole(String role) {
    return switch (role) {
      'parent' => UserRole.parent,
      'teacher' => UserRole.teacher,
      'student' => UserRole.student,
      _ => UserRole.student,
    };
  }
}
