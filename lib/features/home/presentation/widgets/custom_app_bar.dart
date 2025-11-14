import 'package:citizen_mobile_app/core/navigation/screens_routes.dart';
import 'package:citizen_mobile_app/core/theme/color_paletter.dart';
import 'package:citizen_mobile_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:citizen_mobile_app/features/auth/presentation/blocs/auth_event.dart';
import 'package:citizen_mobile_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/home_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  void _showMunicipalityOptions(BuildContext context, GlobalKey anchorKey, String municipalityName, String? userId) {
    final RenderBox renderBox = anchorKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy + renderBox.size.height + 10, position.dx, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: ColorPaletter.cardDark,
      items: <PopupMenuEntry<dynamic>>[
        PopupMenuItem(
          enabled: false,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: ColorPaletter.backgroundDark,
              child: Icon(Icons.location_city, color: ColorPaletter.textWhite),
            ),
            title: const Text("Municipalidad Actual", style: TextStyle(color: ColorPaletter.textWhite)),
            subtitle: Text(municipalityName, style: const TextStyle(color: ColorPaletter.textWhite)),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () => Navigator.pushNamed(context, ScreensRoutes.municipalitySelection, arguments: {'userId': userId},),
          child: const ListTile(
            leading: Icon(Icons.sync, color: ColorPaletter.textWhite),
            title: const Text("Cambiar de municipalidad", style: TextStyle(color: ColorPaletter.textWhite)),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () {
            context.read<AuthBloc>().add(SignOutRequested());
            Navigator.pushNamedAndRemoveUntil(context, ScreensRoutes.signIn, (route) => false);
          },
          child: const ListTile(
            leading: Icon(Icons.logout, color: ColorPaletter.error),
            title: Text("Cerrar sesión", style: TextStyle(color: ColorPaletter.error)),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarKey = GlobalKey();
    final municipalityName = context.select((HomeBloc bloc) => bloc.state.municipalityName);
    final authState = context.read<AuthBloc>().state;
    String? currentUserId;
    if (authState is Authenticated) {
      currentUserId = authState.userId;
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
              color: ColorPaletter.cardDark.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                key: avatarKey,
                onTap: () => _showMunicipalityOptions(context, avatarKey, municipalityName, currentUserId),
                child: const CircleAvatar(
                  backgroundColor: ColorPaletter.primary,
                  child: Text('M', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Tu ubicación', style: TextStyle(color: ColorPaletter.textGrey, fontSize: 12)),
                  Text(
                    municipalityName,
                    style: const TextStyle(color: ColorPaletter.textWhite, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  context.read<HomeBloc>().add(ToggleNotifications());
                },
                child: CircleAvatar(
                  backgroundColor: ColorPaletter.backgroundDark,
                  child: const Icon(Icons.notifications, color: ColorPaletter.textWhite),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}