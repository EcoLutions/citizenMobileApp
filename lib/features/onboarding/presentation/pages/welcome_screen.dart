import 'package:citizen_mobile_app/core/navigation/screens_routes.dart';
import 'package:citizen_mobile_app/core/theme/color_paletter.dart';
import 'package:citizen_mobile_app/core/utils/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset('assets/images/welcome_illustration.png', height: 200),
              const SizedBox(height: 40),
              Text(
                'Transformando la gestión de residuos urbanos',
                textAlign: TextAlign.center,
                style: textTheme.displayLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Colabora, reporta y mantente informado sobre la recolección de basura en tu municipalidad.',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorPaletter.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorPaletter.cardLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ScreensRoutes.signIn);
                },
                child: const Text('Iniciar Sesión'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ScreensRoutes.signUp);
                },
                child: const Text('Crear Cuenta'),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: textTheme.bodySmall?.copyWith(fontSize: 12),
                    children: [
                      const TextSpan(
                          text:
                          'Al unirte a nuestra aplicación, aceptas nuestro '),
                      TextSpan(
                        text: 'Términos de uso',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: ColorPaletter.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlExternal(
                                'https://www.ejemplo.com/terminos');
                          },
                      ),
                      const TextSpan(text: ' y '),
                      TextSpan(
                        text: 'Política de privacidad',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: ColorPaletter.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlExternal(
                                'https://www.ejemplo.com/privacidad');
                          },
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}