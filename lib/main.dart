import 'package:citizen_mobile_app/core/navigation/screens_routes.dart';
import 'package:citizen_mobile_app/core/theme/color_paletter.dart';
import 'package:citizen_mobile_app/core/theme/text_style_paletter.dart';
import 'package:citizen_mobile_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:citizen_mobile_app/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:citizen_mobile_app/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:citizen_mobile_app/features/citizen/presentation/blocs/citizen_bloc.dart';
import 'package:citizen_mobile_app/features/citizen/presentation/pages/citizen_creation_screen.dart';
import 'package:citizen_mobile_app/features/home/domain/entities/trash_container.dart';
import 'package:citizen_mobile_app/features/home/presentation/pages/container_detail_screen.dart';
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
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
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
        brightness: Brightness.dark,
        primaryColor: ColorPaletter.primary,
        scaffoldBackgroundColor: ColorPaletter.backgroundDark,
        fontFamily: 'Roboto',

        textTheme: const TextTheme(
          displayLarge: TextStylePaletter.title,
          headlineMedium: TextStylePaletter.headline,
          bodyLarge: TextStylePaletter.bodyLarge,
          bodyMedium: TextStylePaletter.body,
          labelLarge: TextStylePaletter.button,
          titleMedium: TextStylePaletter.subtitle,
          bodySmall: TextStylePaletter.bodySmall,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: ColorPaletter.backgroundDark,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: ColorPaletter.textWhite),
          titleTextStyle: TextStylePaletter.headline,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ColorPaletter.cardDark,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ColorPaletter.primary, width: 2),
          ),
          hintStyle: TextStylePaletter.body.copyWith(color: ColorPaletter.textGrey),
          labelStyle: TextStylePaletter.body.copyWith(color: ColorPaletter.textGrey),
          prefixIconColor: ColorPaletter.textGrey,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPaletter.primary,
            foregroundColor: ColorPaletter.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStylePaletter.button,
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: ColorPaletter.primary,
            side: const BorderSide(color: ColorPaletter.primary, width: 2),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStylePaletter.button.copyWith(color: ColorPaletter.primary),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                foregroundColor: ColorPaletter.primary,
                textStyle: TextStylePaletter.body.copyWith(fontWeight: FontWeight.bold)
            )
        ),

        cardTheme: CardThemeData(
          color: ColorPaletter.cardDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        listTileTheme: const ListTileThemeData(
          iconColor: ColorPaletter.textWhite,
          textColor: ColorPaletter.textWhite,
        ),

        dialogBackgroundColor: ColorPaletter.cardDark,
        popupMenuTheme: PopupMenuThemeData(
            color: ColorPaletter.cardDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            textStyle: TextStylePaletter.body
        ),

        colorScheme: const ColorScheme.dark(
          primary: ColorPaletter.primary,
          secondary: ColorPaletter.primaryLight,
          background: ColorPaletter.backgroundDark,
          surface: ColorPaletter.cardDark,
          onPrimary: ColorPaletter.white,
          onSecondary: ColorPaletter.black,
          onBackground: ColorPaletter.textWhite,
          onSurface: ColorPaletter.textWhite,
          error: ColorPaletter.error,
          onError: ColorPaletter.white,
        ),
      ),
      initialRoute: ScreensRoutes.splash,
      routes: {
        ScreensRoutes.splash: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => di.sl<AuthBloc>(),
            ),
            BlocProvider(
              create: (_) => di.sl<OnboardingBloc>(),
            ),
          ],
          child: const SplashScreen(),
        ),
        ScreensRoutes.signIn: (context) => BlocProvider(
          create: (_) => di.sl<AuthBloc>(),
          child: const SignInScreen(),
        ),
        ScreensRoutes.signUp: (context) => BlocProvider(
          create: (_) => di.sl<AuthBloc>(),
          child: const SignUpScreen(),
        ),
        ScreensRoutes.citizenCreation: (context) {
          final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return BlocProvider(
            create: (_) => di.sl<CitizenBloc>(),
            child: CitizenCreationScreen(
              userId: args['userId'],
              districtId: args['districtId'],
              citizenId: args['citizenId'] as String?,
            ),
          );
        },
        ScreensRoutes.welcome: (context) => const WelcomeScreen(),
        ScreensRoutes.municipalitySelection: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
              di.sl<OnboardingBloc>()..add(LoadAllMunicipalities()),
            ),
            BlocProvider(
              create: (_) => di.sl<CitizenBloc>(),
            ),
          ],
          child: const MunicipalitySelectionScreen(),
        ),
        ScreensRoutes.home: (context) => const HomeScreen(),
        ScreensRoutes.reportIncident: (context) => const ReportIncidentScreen(),
        ScreensRoutes.notifications: (context) => const NotificationScreen(),
        ScreensRoutes.containerDetail: (context) {
          final container =
          ModalRoute.of(context)!.settings.arguments as TrashContainer;
          return ContainerDetailScreen(container: container);
        },
      },
    );
  }
}