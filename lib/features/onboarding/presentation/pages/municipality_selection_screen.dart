import 'package:citizen_mobile_app/core/navigation/screens_routes.dart';
import 'package:citizen_mobile_app/core/theme/color_paletter.dart';
import 'package:citizen_mobile_app/core/utils/url_launcher.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/blocs/onboarding_bloc.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/blocs/onboarding_event.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/blocs/onboarding_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:convert';
import 'package:citizen_mobile_app/core/di/injection_container.dart' as di;
import 'package:citizen_mobile_app/features/citizen/domain/entities/citizen.dart';
import 'package:citizen_mobile_app/features/citizen/presentation/blocs/citizen_bloc.dart';
import 'package:citizen_mobile_app/features/citizen/presentation/blocs/citizen_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MunicipalitySelectionScreen extends StatefulWidget {
  const MunicipalitySelectionScreen({super.key});

  @override
  State<MunicipalitySelectionScreen> createState() =>
      _MunicipalitySelectionScreenState();
}

class _MunicipalitySelectionScreenState
    extends State<MunicipalitySelectionScreen> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final userId = args?['userId'] as String?;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige tu municipalidad'),
      ),
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompleted) {
            final prefs = di.sl<SharedPreferences>();
            final citizenJson = prefs.getString('citizen_profile');

            if (citizenJson != null) {
              final citizenMap =
              jsonDecode(citizenJson) as Map<String, dynamic>;
              final citizen = Citizen.fromJson(citizenMap);

              context.read<CitizenBloc>().add(UpdateCitizenRequested(
                citizenId: citizen.id,
                districtId: state.municipality.id,
                firstName: citizen.firstName,
                lastName: citizen.lastName,
                email: citizen.email,
                phoneNumber: citizen.phoneNumber,
              ));

              Navigator.pushNamedAndRemoveUntil(
                  context, ScreensRoutes.home, (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, ScreensRoutes.citizenCreation, (route) => false,
                  arguments: {
                    'userId': userId,
                    'districtId': state.municipality.id,
                  });
            }
          }
          if (state is MunicipalitySelectionState) {
            if (state.searchQuery != _textController.text) {
              _textController.text = state.searchQuery;
              _textController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _textController.text.length));
            }
          }
        },
        builder: (context, state) {
          final selectionState = state is MunicipalitySelectionState
              ? state
              : const MunicipalitySelectionState();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Buscar municipalidad...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (query) {
                    if (query != selectionState.searchQuery) {
                      context
                          .read<OnboardingBloc>()
                          .add(FilterMunicipality(query));
                    }
                  },
                ),
                const SizedBox(height: 10),
                if (selectionState.isLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (selectionState.searchResults.isNotEmpty ||
                    selectionState.searchQuery.isEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: selectionState.searchResults.length,
                      itemBuilder: (context, index) {
                        final municipality =
                        selectionState.searchResults[index];
                        return Card(
                          color: ColorPaletter.cardLight,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: ColorPaletter.cardDark,
                              child: Icon(
                                Icons.location_city_outlined,
                                color: ColorPaletter.textGrey,
                              ),
                            ),
                            title: Text(
                              municipality.name,
                              style: textTheme.bodyLarge,
                            ),
                            onTap: () {
                              context
                                  .read<OnboardingBloc>()
                                  .add(SelectMunicipality(municipality));
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        );
                      },
                    ),
                  )
                else if (selectionState.searchResults.isEmpty &&
                      selectionState.searchQuery.isNotEmpty &&
                      !selectionState.isLoading)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_city_outlined,
                              size: 100,
                              color: ColorPaletter.cardLight.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No se encontraron municipalidades',
                              textAlign: TextAlign.center,
                              style: textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorPaletter.cardLight)),
                    const SizedBox(width: 8),
                    Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorPaletter.primary)),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: selectionState.selectedMunicipality != null
                      ? () => context
                      .read<OnboardingBloc>()
                      .add(ConfirmMunicipalitySelection())
                      : null,
                  child: const Text('Continuar'),
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
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}