import 'package:citizen_mobile_app/core/navigation/screens_routes.dart';
import 'package:citizen_mobile_app/core/theme/color_paletter.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/blocs/onboarding_bloc.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/blocs/onboarding_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        Future.delayed(const Duration(seconds: 2), () {
          if (state is OnboardingCompleted) {
            Navigator.pushReplacementNamed(context, ScreensRoutes.home);
          } else {
            Navigator.pushReplacementNamed(context, ScreensRoutes.welcome);
          }
        });
      },
      child: Scaffold(
        backgroundColor: ColorPaletter.secondary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: 0.83,
                  child: Image.asset('assets/images/login_logo.png', width: 220, height: 220),
                ),
              ),
              const Text(
                'CITIZENS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}