import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/db/app_database.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/parent_repository_impl.dart';
import '../../data/repositories/student_repository_impl.dart';
import '../../data/repositories/teacher_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/parent_repository.dart';
import '../../domain/repositories/student_repository.dart';
import '../../domain/repositories/teacher_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(databaseProvider));
});

final parentRepositoryProvider = Provider<ParentRepository>((ref) {
  return ParentRepositoryImpl(ref.read(databaseProvider));
});

final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  return TeacherRepositoryImpl(ref.read(databaseProvider));
});

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepositoryImpl(ref.read(databaseProvider));
});
