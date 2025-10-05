import 'package:citizen_mobile_app/core/navigation/screens_routes.dart';
import 'package:citizen_mobile_app/features/home/presentation/pages/home_screen.dart';
import 'package:citizen_mobile_app/features/notifications/presentation/pages/notification_screen.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/blocs/onboarding_bloc.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/blocs/onboarding_event.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/pages/municipality_selection_screen.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/pages/welcome_screen.dart';
import 'package:citizen_mobile_app/features/reports/presentation/pages/report_incident_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizen_mobile_app/core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const WasteTrackApp());
}

class WasteTrackApp extends StatelessWidget {
  const WasteTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WasteTrack Citizens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
      ),
      initialRoute: ScreensRoutes.splash,
      routes: {
        ScreensRoutes.splash: (context) => BlocProvider(
          create: (_) => di.sl<OnboardingBloc>()..add(CheckOnboardingStatus()),
          child: const SplashScreen(),
        ),
        ScreensRoutes.welcome: (context) => const WelcomeScreen(),
        ScreensRoutes.municipalitySelection: (context) => BlocProvider(
          create: (_) => di.sl<OnboardingBloc>(),
          child: const MunicipalitySelectionScreen(),
        ),
        ScreensRoutes.home: (context) => const HomeScreen(),
        ScreensRoutes.reportIncident: (context) => const ReportIncidentScreen(),
        ScreensRoutes.notifications: (context) => const NotificationScreen(),
      },
    );
  }
}