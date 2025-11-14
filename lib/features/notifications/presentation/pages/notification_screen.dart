import 'package:citizen_mobile_app/core/theme/color_paletter.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/home_event.dart';
import 'package:citizen_mobile_app/features/notifications/domain/entities/notification.dart'
as app_notification; // Renombrado para evitar conflicto
import 'package:citizen_mobile_app/features/notifications/presentation/blocs/notification_bloc.dart';
import 'package:citizen_mobile_app/features/notifications/presentation/blocs/notification_event.dart';
import 'package:citizen_mobile_app/features/notifications/presentation/blocs/notification_state.dart';
import 'package:flutter/material.dart'; // Importación normal
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizen_mobile_app/core/di/injection_container.dart' as di;
import 'package:permission_handler/permission_handler.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<NotificationBloc>()..add(LoadNotifications()),
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.3,
            maxChildSize: 0.85,
            builder: (_, controller) {
              return Container(
                decoration: const BoxDecoration(
                  color: ColorPaletter.cardDark,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: ColorPaletter.cardLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<NotificationBloc, NotificationState>(
                        builder: (context, state) {
                          if (state is NotificationLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (state is NotificationLoaded) {
                            return _buildNotificationsList(
                                context,
                                controller,
                                state.notifications,
                                state.permissionStatus);
                          }
                          if (state is NotificationEmpty) {
                            return _buildNotificationsList(
                                context, controller, [], state.permissionStatus);
                          }
                          if (state is NotificationError) {
                            return Center(child: Text(state.message));
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsList(
      BuildContext context,
      ScrollController controller,
      List<app_notification.Notification> notifications,
      PermissionStatus permissionStatus) {
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverToBoxAdapter(child: _Header(permissionStatus: permissionStatus)),
        if (notifications.isEmpty)
          SliverFillRemaining(child: _buildEmptyState(context))
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildNotificationCard(context, notifications[index]),
              childCount: notifications.length,
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text(
            'No tienes notificaciones nuevas',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  }

  Widget _buildNotificationCard(
      BuildContext context, app_notification.Notification notification) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: ColorPaletter.cardLight,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: ColorPaletter.primary.withOpacity(0.1),
          child: const Icon(Icons.notifications_active_outlined,
              color: ColorPaletter.primary),
        ),
        title: Text(notification.title,
            style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text(notification.body,
            style: Theme.of(context).textTheme.bodySmall),
        trailing: IconButton(
          icon: const Icon(Icons.close,
              size: 20, color: ColorPaletter.textGrey),
          onPressed: () {
            context
                .read<NotificationBloc>()
                .add(DismissNotification(notification.id));
          },
        ),
      ),
    );
  }

class _Header extends StatelessWidget {
  final PermissionStatus permissionStatus;
  const _Header({required this.permissionStatus});

  @override
  Widget build(BuildContext context) {
    final bool areNotificationsEnabled =
        permissionStatus.isGranted || permissionStatus.isLimited;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Notificaciones",
                  style: Theme.of(context).textTheme.headlineMedium),
              IconButton(
                icon: const Icon(Icons.close, color: ColorPaletter.textGrey),
                onPressed: () =>
                    context.read<HomeBloc>().add(ToggleNotifications()),
              ),
            ],
          ),
          if (!areNotificationsEnabled)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                    foregroundColor: ColorPaletter.warning,
                    backgroundColor: ColorPaletter.warning.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                icon: const Icon(Icons.warning_amber_rounded, size: 20),
                label: const Text("Activar notificaciones"),
                onPressed: () => context
                    .read<NotificationBloc>()
                    .add(OpenNotificationSettings()),
              ),
            ),
        ],
      ),
    );
  }
}