import 'dart:io';
import 'package:citizen_mobile_app/core/theme/color_paletter.dart';
import 'package:citizen_mobile_app/features/reports/presentation/blocs/report_bloc.dart';
import 'package:citizen_mobile_app/features/reports/presentation/blocs/report_event.dart';
import 'package:citizen_mobile_app/features/reports/presentation/blocs/report_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizen_mobile_app/core/di/injection_container.dart' as di;

import '../../../../core/theme/text_style_paletter.dart';

class ReportIncidentScreen extends StatelessWidget {
  const ReportIncidentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ReportBloc>(),
      child: SafeArea(
        child: BlocConsumer<ReportBloc, ReportState>(
          listener: (context, state) {
            if (state.status == ReportStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reporte enviado con éxito.'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
            }
            if (state.status == ReportStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Ocurrió un error.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 120, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tipo de incidencia', style: TextStylePaletter.subtitle),
                  const SizedBox(height: 8),
                  _buildTypeSelector(context, state.type),
                  const SizedBox(height: 24),
                  const Text('Descripción', style: TextStylePaletter.subtitle),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Describe el problema...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: ColorPaletter.primary),
                      ),
                    ),
                    maxLines: 4,
                    onChanged: (value) {
                      context.read<ReportBloc>().add(DescriptionChanged(value));
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text('Adjuntar Fotos (Opcional)', style: TextStylePaletter.subtitle),
                  const SizedBox(height: 8),
                  _buildPhotoGrid(context, state.photos),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPaletter.primary,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: state.isFormValid && state.status != ReportStatus.submitting
                        ? () => context.read<ReportBloc>().add(SubmitReport())
                        : null,
                    child: state.status == ReportStatus.submitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Enviar Reporte', style: TextStylePaletter.button),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTypeSelector(BuildContext context, String currentType) {
    final types = [
      "Contenedor Lleno",
      "Basura en la calle",
      "Contenedor Dañado",
      "Punto de Acopio Ilegal",
      "Requiere Barrido",
      "Otro"
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: types.map((type) {
          final isSelected = type == currentType;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  context.read<ReportBloc>().add(ReportTypeChanged(type));
                }
              },
              selectedColor: ColorPaletter.primary,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color),
              backgroundColor: ColorPaletter.textGrey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: isSelected ? ColorPaletter.primary : Colors.grey)
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPhotoGrid(BuildContext context, List<File> photos) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photos.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        if (index == photos.length) {
          return GestureDetector(
            onTap: () => context.read<ReportBloc>().add(AddPhoto()),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add_a_photo, color: Colors.grey),
            ),
          );
        }
        final photo = photos[index];
        return Stack(
          children: [
            Image.file(photo, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => context.read<ReportBloc>().add(RemovePhoto(photo)),
                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}