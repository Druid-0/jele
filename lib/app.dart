import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/config/api_config.dart';
import 'data/local/app_database.dart';
import 'data/local/school_local_data_source.dart';
import 'data/remote/school_remote_data_source.dart';
import 'data/repositories/drift_school_repository.dart';
import 'domain/repositories/school_repository.dart';
import 'presentation/screens/app_router.dart';
import 'presentation/viewmodels/app_state_view_model.dart';

class GreetingMessageApp extends StatelessWidget {
  const GreetingMessageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (_, database) => database.close(),
        ),
        Provider<SchoolLocalDataSource>(
          create: (context) => SchoolLocalDataSource(context.read<AppDatabase>()),
        ),
        Provider<SchoolRemoteDataSource>(
          create: (_) => SchoolRemoteDataSource(baseUrl: ApiConfig.baseUrl),
        ),
        Provider<SchoolRepository>(
          create: (context) => DriftSchoolRepository(
            context.read<SchoolLocalDataSource>(),
            remote: context.read<SchoolRemoteDataSource>(),
            enableRemote: ApiConfig.enableRemote,
          ),
        ),
        ChangeNotifierProvider<AppStateViewModel>(
          create: (context) => AppStateViewModel(repository: context.read<SchoolRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Greeting Message',
        theme: AppTheme.lightTheme,
        home: const AppRouter(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
