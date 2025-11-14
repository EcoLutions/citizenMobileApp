import 'package:citizen_mobile_app/features/citizen/presentation/blocs/citizen_bloc.dart';
import 'package:citizen_mobile_app/features/citizen/presentation/blocs/citizen_event.dart';
import 'package:citizen_mobile_app/features/citizen/presentation/blocs/citizen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizen_mobile_app/core/theme/color_paletter.dart';
import '../../../../core/navigation/screens_routes.dart';

class CitizenCreationScreen extends StatefulWidget {
  final String userId;
  final String districtId;
  final String? citizenId;

  const CitizenCreationScreen({
    super.key,
    required this.userId,
    required this.districtId,
    this.citizenId,
  });

  @override
  State<CitizenCreationScreen> createState() => _CitizenCreationScreenState();
}

class _CitizenCreationScreenState extends State<CitizenCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completa tu perfil'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<CitizenBloc, CitizenState>(
        listener: (context, state) {
          if (state is CitizenCreated || state is CitizenUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Perfil creado con éxito!'),
                backgroundColor: ColorPaletter.success,
              ),
            );
            Navigator.of(context).pushReplacementNamed(ScreensRoutes.home);
          } else if (state is CitizenError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorPaletter.error,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Casi listo...',
                      style: textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Por favor, proporciona tu información personal',
                      style: textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Apellido',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu apellido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Por favor ingresa un email válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Número de teléfono',
                        prefixIcon: Icon(Icons.phone_outlined),
                        prefixText: '+51 ',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu número de teléfono';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<CitizenBloc, CitizenState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is CitizenLoading
                              ? null
                              : () {
                            if (_formKey.currentState!.validate()) {
                              if (widget.citizenId != null) {
                                context.read<CitizenBloc>().add(
                                  UpdateCitizenRequested(
                                    citizenId: widget.citizenId!,
                                    districtId: widget.districtId,
                                    firstName: _firstNameController
                                        .text
                                        .trim(),
                                    lastName: _lastNameController
                                        .text
                                        .trim(),
                                    email:
                                    _emailController.text.trim(),
                                    phoneNumber:
                                    _phoneController.text.trim(),
                                  ),
                                );
                              } else {
                                context.read<CitizenBloc>().add(
                                  CreateCitizenRequested(
                                    userId: widget.userId,
                                    districtId: widget.districtId,
                                    firstName: _firstNameController
                                        .text
                                        .trim(),
                                    lastName: _lastNameController
                                        .text
                                        .trim(),
                                    email:
                                    _emailController.text.trim(),
                                    phoneNumber:
                                    _phoneController.text.trim(),
                                  ),
                                );
                              }
                            }
                          },
                          child: state is CitizenLoading
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : Text(
                            widget.citizenId != null
                                ? 'Actualizar Perfil'
                                : 'Completar Perfil',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}