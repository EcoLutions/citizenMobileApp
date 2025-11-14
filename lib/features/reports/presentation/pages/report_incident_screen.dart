import 'dart:io';
import 'package:citizen_mobile_app/core/theme/color_paletter.dart';
import 'package:citizen_mobile_app/features/reports/domain/entities/report_type.dart';
import 'package:citizen_mobile_app/features/reports/presentation/blocs/report_bloc.dart';
import 'package:citizen_mobile_app/features/reports/presentation/blocs/report_event.dart';
import 'package:citizen_mobile_app/features/reports/presentation/blocs/report_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizen_mobile_app/core/di/injection_container.dart' as di;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/theme/text_style_paletter.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/home_event.dart';

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
                  backgroundColor: ColorPaletter.success,
                ),
              );
              context.read<HomeBloc>().add(Navigate(0));
              context.read<ReportBloc>().add(ResetReportForm());
            }
            if (state.status == ReportStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Ocurrió un error.'),
                  backgroundColor: ColorPaletter.error,
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 120, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tipo de incidencia',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 16),
                    _buildTypeSelector(context, state.type),
                    const SizedBox(height: 24),
                    Text('Ubicación',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 16),
                    _buildLocationSection(context, state),
                    const SizedBox(height: 24),
                    Text('Descripción',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: state.description,
                      decoration: const InputDecoration(
                        hintText: 'Describe el problema...',
                      ),
                      maxLines: 4,
                      onChanged: (value) {
                        context.read<ReportBloc>().add(DescriptionChanged(value));
                      },
                    ),
                    const SizedBox(height: 24),
                    Text('Adjuntar Fotos (Opcional)',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 16),
                    _buildPhotoGrid(context, state.photos),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: state.isFormValid &&
                          state.status != ReportStatus.submitting
                          ? () =>
                          context.read<ReportBloc>().add(SubmitReport())
                          : null,
                      child: state.status == ReportStatus.submitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Enviar Reporte'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTypeSelector(BuildContext context, ReportType currentType) {
    final types = ReportType.values;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: types.map((type) {
          final isSelected = type == currentType;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(type.displayName),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  context.read<ReportBloc>().add(ReportTypeChanged(type));
                }
              },
              selectedColor: ColorPaletter.primary,
              backgroundColor: ColorPaletter.cardLight,
              labelStyle: TextStyle(
                  color: isSelected ? ColorPaletter.white : ColorPaletter.textPrimary,
                  fontWeight: FontWeight.w600
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                      color: isSelected
                          ? ColorPaletter.primary
                          : Colors.transparent)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context, ReportState state) {
    return Column(
      children: [
        if (state.latitude != null && state.longitude != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorPaletter.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorPaletter.success),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: ColorPaletter.success),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ubicación: ${state.latitude!.toStringAsFixed(5)}, ${state.longitude!.toStringAsFixed(5)}',
                    style: const TextStyle(color: ColorPaletter.success, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorPaletter.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorPaletter.warning),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: ColorPaletter.warning),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ubicación requerida',
                    style: const TextStyle(color: ColorPaletter.warning, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => _getCurrentLocation(context),
          icon: const Icon(Icons.my_location),
          label: const Text('Obtener ubicación actual'),
          style: ElevatedButton.styleFrom(
              backgroundColor: ColorPaletter.cardLight,
              foregroundColor: ColorPaletter.textWhite
          ),
        ),
      ],
    );
  }

  Future<void> _getCurrentLocation(BuildContext context) async {
    try {
      final permission = await Permission.location.request();
      if (permission.isGranted) {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        context.read<ReportBloc>().add(
          LocationChanged(position.latitude, position.longitude),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permiso de ubicación denegado'),
            backgroundColor: ColorPaletter.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error obteniendo ubicación: $e'),
          backgroundColor: ColorPaletter.error,
        ),
      );
    }
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
            onTap: () => _showImageSourceDialog(context),
            child: Container(
              decoration: BoxDecoration(
                color: ColorPaletter.cardLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add_a_photo_outlined, color: ColorPaletter.textGrey),
            ),
          );
        }
        final photo = photos[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(photo, fit: BoxFit.cover),
              Positioned(
                right: 4,
                top: 4,
                child: GestureDetector(
                  onTap: () =>
                      context.read<ReportBloc>().add(RemovePhoto(photo)),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImageSourceDialog(BuildContext outerContext) {
    showDialog(
      context: outerContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Seleccionar fuente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Tomar foto'),
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  outerContext
                      .read<ReportBloc>()
                      .add(AddPhoto(ImageSource.camera));
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Elegir de galería'),
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  outerContext
                      .read<ReportBloc>()
                      .add(AddPhoto(ImageSource.gallery));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}