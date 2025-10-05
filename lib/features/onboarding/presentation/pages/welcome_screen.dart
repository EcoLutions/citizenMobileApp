import 'package:citizen_mobile_app/core/navigation/screens_routes.dart';
import 'package:citizen_mobile_app/core/theme/color_paletter.dart';
import 'package:citizen_mobile_app/core/theme/text_style_paletter.dart';
import 'package:citizen_mobile_app/core/utils/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Transformando la gestión de residuos urbanos',
                textAlign: TextAlign.center,
                style: TextStylePaletter.title,
              ),
              const SizedBox(height: 16),
              const Text(
                'Colabora, reporta y mantente informado sobre la recolección de basura en tu municipalidad.',
                textAlign: TextAlign.center,
                style: TextStylePaletter.subtitle,
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
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPaletter.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, ScreensRoutes.municipalitySelection);
                },
                child: const Text('Continuar', style: TextStylePaletter.button),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12,
                      color: ColorPaletter.textGrey,
                      fontFamily: 'Roboto',
                    ),
                    children: [
                      const TextSpan(text: 'Al unirte a nuestra aplicación, aceptas nuestro '),
                      TextSpan(
                        text: 'Términos de uso',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlExternal('https://www.ejemplo.com/terminos');
                          },
                      ),
                      const TextSpan(text: ' y '),
                      TextSpan(
                        text: 'Política de privacidad',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlExternal('https://www.ejemplo.com/privacidad');
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