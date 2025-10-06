import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final int navIndex;
  final bool showNotifications;
  final String municipalityName;

  const HomeState({
    this.navIndex = 0,
    this.showNotifications = false,
    this.municipalityName = "Loading...",
  });

  HomeState copyWith({
    int? navIndex,
    bool? showNotifications,
    String? municipalityName,
  }) {
    return HomeState(
      navIndex: navIndex ?? this.navIndex,
      showNotifications: showNotifications ?? this.showNotifications,
      municipalityName: municipalityName ?? this.municipalityName,
    );
  }

  @override
  List<Object?> get props => [navIndex, showNotifications, municipalityName];
}