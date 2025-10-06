import 'package:citizen_mobile_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/home_event.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/home_state.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/map_bloc.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/map_event.dart';
import 'package:citizen_mobile_app/features/home/presentation/pages/map_screen.dart';
import 'package:citizen_mobile_app/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:citizen_mobile_app/features/home/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:citizen_mobile_app/features/notifications/presentation/pages/notification_screen.dart';
import 'package:citizen_mobile_app/features/reports/presentation/pages/report_incident_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizen_mobile_app/core/di/injection_container.dart' as di;


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<HomeBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<MapBloc>()..add(LoadMapAtCurrentLocation()),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Stack(
              children: [
                IndexedStack(
                  index: state.navIndex,
                  children: const [
                    MapScreen(),
                    ReportIncidentScreen(),
                  ],
                ),
                const CustomAppBar(),
                CustomBottomNavBar(
                  currentIndex: state.navIndex,
                  onTap: (index) => context.read<HomeBloc>().add(Navigate(index)),
                ),
                if (state.showNotifications) const NotificationScreen(),
              ],
            );
          },
        ),
      ),
    );
  }
}