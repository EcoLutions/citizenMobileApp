import 'package:citizen_mobile_app/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:citizen_mobile_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:citizen_mobile_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:citizen_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:citizen_mobile_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:citizen_mobile_app/features/citizen/data/datasource/citizen_remote_data_source.dart';
import 'package:citizen_mobile_app/features/citizen/data/repositories/citizen_repository_impl.dart';
import 'package:citizen_mobile_app/features/citizen/domain/repositories/citizen_repository.dart';
import 'package:citizen_mobile_app/features/citizen/presentation/blocs/citizen_bloc.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/map_bloc.dart';
import 'package:citizen_mobile_app/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:citizen_mobile_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:citizen_mobile_app/features/notifications/presentation/blocs/notification_bloc.dart';
import 'package:citizen_mobile_app/features/reports/data/datasource/reports_remote_data_source.dart';
import 'package:citizen_mobile_app/features/reports/data/repositories/incident_repository_impl.dart';
import 'package:citizen_mobile_app/features/reports/domain/repositories/incident_repository.dart';
import 'package:citizen_mobile_app/features/reports/presentation/blocs/report_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:citizen_mobile_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:citizen_mobile_app/features/home/domain/repositories/home_repository.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/blocs/onboarding_bloc.dart';
import 'package:citizen_mobile_app/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:citizen_mobile_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:citizen_mobile_app/features/onboarding/data/datasource/onboarding_remote_data_source.dart';
import 'package:citizen_mobile_app/features/onboarding/data/datasource/onboarding_local_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => AuthBloc(
    repository: sl(),
    citizenRepository: sl(),
    onboardingRepository: sl(),
    sharedPreferences: sl(),
  ));
  sl.registerFactory(() => CitizenBloc(
    repository: sl(),
    sharedPreferences: sl(),
  ));
  sl.registerFactory(() => OnboardingBloc(
    repository: sl(),
    sharedPreferences: sl(),
  ));
  sl.registerFactory(() => MapBloc(
      homeRepository: sl(),
    onboardingRepository: sl(),
  ));
  sl.registerFactory(() => ReportBloc(
        incidentRepository: sl(),
        authLocalDataSource: sl(),
      ));
  sl.registerFactory(() => NotificationBloc(notificationRepository: sl()));
  sl.registerFactory(() => HomeBloc(onboardingRepository: sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ReportsRemoteDataSource>(
    () => ReportsRemoteDataSourceImpl(
      client: sl(),
      authLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<OnboardingRemoteDataSource>(
    () => OnboardingRemoteDataSourceImpl(
      client: sl(),
      authLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<CitizenRemoteDataSource>(
    () => CitizenRemoteDataSourceImpl(
      client: sl(),
      authLocalDataSource: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      sharedPreferences: sl(),
    ),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      client: sl(),
      authLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<IncidentRepository>(
    () => IncidentRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<CitizenRepository>(
    () => CitizenRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl());

  // External
  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}