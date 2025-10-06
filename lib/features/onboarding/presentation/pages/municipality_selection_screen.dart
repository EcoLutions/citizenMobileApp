import 'package:citizen_mobile_app/core/navigation/screens_routes.dart';
import 'package:citizen_mobile_app/core/theme/color_paletter.dart';
import 'package:citizen_mobile_app/core/utils/url_launcher.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/blocs/onboarding_bloc.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/blocs/onboarding_event.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/blocs/onboarding_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MunicipalitySelectionScreen extends StatefulWidget {
  const MunicipalitySelectionScreen({super.key});

  @override
  State<MunicipalitySelectionScreen> createState() => _MunicipalitySelectionScreenState();
}

class _MunicipalitySelectionScreenState extends State<MunicipalitySelectionScreen> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige tu municipalidad'),
      ),
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompleted) {
            Navigator.pushNamedAndRemoveUntil(context, ScreensRoutes.home, (route) => false);
          }
          if (state is MunicipalitySelectionState) {
            if (state.searchQuery != _textController.text) {
              _textController.text = state.searchQuery;
              _textController.selection = TextSelection.fromPosition(TextPosition(offset: _textController.text.length));
            }
          }
        },
        builder: (context, state) {
          final selectionState = state is MunicipalitySelectionState ? state : const MunicipalitySelectionState();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Buscar municipalidad...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: ColorPaletter.primary, width: 2),
                    ),
                  ),
                  onChanged: (query) {
                    context.read<OnboardingBloc>().add(SearchMunicipality(query));
                  },
                ),
                const SizedBox(height: 10),

                if (selectionState.searchResults.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: selectionState.searchResults.length,
                      itemBuilder: (context, index) {
                        final municipality = selectionState.searchResults[index];
                        return Card(
                          color: ColorPaletter.white,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: ColorPaletter.textGrey,
                              child: Text(
                                municipality.substring(0, 1),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              municipality,
                              style: const TextStyle(color: Colors.black45),
                            ),
                            onTap: () {
                              context.read<OnboardingBloc>().add(SelectMunicipality(municipality));
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                if (selectionState.searchResults.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_city_outlined,
                            size: 100,
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Ingresa el nombre de tu municipalidad\npara ver los resultados.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorPaletter.textGrey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[600])),
                    const SizedBox(width: 8),
                    Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: ColorPaletter.primary)),
                  ],
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: selectionState.selectedMunicipality != null ? ColorPaletter.primary : Colors.grey,
                  ),
                  onPressed: selectionState.selectedMunicipality != null
                      ? () => context.read<OnboardingBloc>().add(ConfirmMunicipalitySelection())
                      : null,
                  child: const Text('Continuar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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