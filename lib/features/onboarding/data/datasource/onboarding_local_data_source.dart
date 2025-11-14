import 'package:citizen_mobile_app/features/onboarding/domain/entities/municipality.dart';

abstract class OnboardingLocalDataSource {
  Future<List<Municipality>> getDefaultMunicipalities();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  @override
  Future<List<Municipality>> getDefaultMunicipalities() async {
    // Simulate network delay for consistency
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      Municipality(
        id: '1',
        name: 'La Victoria, Lima',
        code: 'LVL',
        boundaries: '',
        operationalStatus: 'active',
        serviceStartDate: '',
        subscriptionId: '',
        maxVehicles: 0,
        maxDrivers: 0,
        maxContainers: 0,
        primaryAdminEmail: '',
        createdAt: '',
        updatedAt: '',
      ),
      Municipality(
        id: '2',
        name: 'San Isidro, Lima',
        code: 'SIL',
        boundaries: '',
        operationalStatus: 'active',
        serviceStartDate: '',
        subscriptionId: '',
        maxVehicles: 0,
        maxDrivers: 0,
        maxContainers: 0,
        primaryAdminEmail: '',
        createdAt: '',
        updatedAt: '',
      ),
      Municipality(
        id: '3',
        name: 'Miraflores, Lima',
        code: 'ML',
        boundaries: '',
        operationalStatus: 'active',
        serviceStartDate: '',
        subscriptionId: '',
        maxVehicles: 0,
        maxDrivers: 0,
        maxContainers: 0,
        primaryAdminEmail: '',
        createdAt: '',
        updatedAt: '',
      ),
      Municipality(
        id: '4',
        name: 'Barranco, Lima',
        code: 'BL',
        boundaries: '',
        operationalStatus: 'active',
        serviceStartDate: '',
        subscriptionId: '',
        maxVehicles: 0,
        maxDrivers: 0,
        maxContainers: 0,
        primaryAdminEmail: '',
        createdAt: '',
        updatedAt: '',
      ),
      Municipality(
        id: '5',
        name: 'Surco, Lima',
        code: 'SL',
        boundaries: '',
        operationalStatus: 'active',
        serviceStartDate: '',
        subscriptionId: '',
        maxVehicles: 0,
        maxDrivers: 0,
        maxContainers: 0,
        primaryAdminEmail: '',
        createdAt: '',
        updatedAt: '',
      ),
      Municipality(
        id: '6',
        name: 'San Borja, Lima',
        code: 'SBL',
        boundaries: '',
        operationalStatus: 'active',
        serviceStartDate: '',
        subscriptionId: '',
        maxVehicles: 0,
        maxDrivers: 0,
        maxContainers: 0,
        primaryAdminEmail: '',
        createdAt: '',
        updatedAt: '',
      ),
    ];
  }
}