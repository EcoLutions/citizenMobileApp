import 'package:citizen_mobile_app/features/home/domain/entities/trash_container.dart';
import 'package:citizen_mobile_app/core/theme/color_paletter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContainerDetailScreen extends StatelessWidget {
  final TrashContainer container;

  const ContainerDetailScreen({super.key, required this.container});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Contenedor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorPaletter.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getStatusColor(container.status),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _getStatusColor(container.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: _getStatusColor(container.status),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contenedor ID',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          container.id.substring(0, 8),
                          style: Theme.of(context).textTheme.headlineMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          container.status.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: _getStatusColor(container.status),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(
              context,
              'Nivel de Llenado',
              '${container.currentFillLevel}%',
              Icons.water_drop_outlined,
              _getFillLevelColor(container.fillLevel),
              subtitle: _getFillLevelText(container.level),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Especificaciones',
                        style: Theme.of(context).textTheme.headlineMedium
                    ),
                    const SizedBox(height: 16),
                    _buildSpecRow(context, 'Tipo', container.containerType),
                    _buildSpecRow(context, 'Volumen', '${container.volumeLiters}L'),
                    _buildSpecRow(context, 'Peso Máx.', '${container.maxFillLevel}kg'),
                    _buildSpecRow(context, 'Sensor ID', container.deviceId),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Información de Colección',
                        style: Theme.of(context).textTheme.headlineMedium
                    ),
                    const SizedBox(height: 16),
                    _buildSpecRow(context, 'Última Colección',
                        _formatDate(container.lastCollectionDate)),
                    _buildSpecRow(context, 'Frecuencia',
                        'Cada ${container.collectionFrequencyDays} días'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Sistema',
                        style: Theme.of(context).textTheme.headlineMedium
                    ),
                    const SizedBox(height: 16),
                    _buildSpecRow(context, 'Última Lectura',
                        _formatDateTime(container.lastReadingTimestamp)),
                    _buildSpecRow(
                        context, 'Creado', _formatDateTime(container.createdAt)),
                    _buildSpecRow(
                        context, 'Actualizado', _formatDateTime(container.updatedAt)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String value, IconData icon,
      Color iconColor,
      {String? subtitle}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: ColorPaletter.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: iconColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              label,
              style: Theme.of(context).textTheme.bodySmall
          ),
          Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return ColorPaletter.levelLow;
      case 'maintenance':
        return ColorPaletter.levelMedium;
      case 'inactive':
        return ColorPaletter.levelFull;
      default:
        return ColorPaletter.primary;
    }
  }

  Color _getFillLevelColor(double fillLevel) {
    if (fillLevel >= 0.8) {
      return ColorPaletter.levelFull;
    } else if (fillLevel >= 0.5) {
      return ColorPaletter.levelMedium;
    } else {
      return ColorPaletter.levelLow;
    }
  }

  String _getFillLevelText(ContainerLevel level) {
    switch (level) {
      case ContainerLevel.low:
        return 'Nivel bajo';
      case ContainerLevel.medium:
        return 'Nivel medio';
      case ContainerLevel.full:
        return 'Nivel alto - necesita recolección';
    }
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatDateTime(String dateTimeString) {
    if (dateTimeString.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }
}