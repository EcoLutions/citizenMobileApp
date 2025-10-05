import 'package:citizen_mobile_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/map_bloc.dart';
import 'package:citizen_mobile_app/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:citizen_mobile_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:citizen_mobile_app/features/notifications/presentation/blocs/notification_bloc.dart';
import 'package:citizen_mobile_app/features/reports/data/repositories/incident_repository_impl.dart';
import 'package:citizen_mobile_app/features/reports/domain/repositories/incident_repository.dart';
import 'package:citizen_mobile_app/features/reports/presentation/blocs/report_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:citizen_mobile_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:citizen_mobile_app/features/home/domain/repositories/home_repository.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/blocs/onboarding_bloc.dart';
import 'package:citizen_mobile_app/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:citizen_mobile_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => OnboardingBloc(repository: sl()));
  sl.registerFactory(() => MapBloc(homeRepository: sl()));
  sl.registerFactory(() => ReportBloc(incidentRepository: sl()));
  sl.registerFactory(() => NotificationBloc(notificationRepository: sl()));
  sl.registerFactory(() => HomeBloc(onboardingRepository: sl()));

  // Repositories
  sl.registerLazySingleton<OnboardingRepository>(
          () => OnboardingRepositoryImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl());
  sl.registerLazySingleton<IncidentRepository>(() => IncidentRepositoryImpl());
  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}