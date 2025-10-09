abstract class HomeEvent {}

class LoadHomeData extends HomeEvent {}

class Navigate extends HomeEvent {
  final int index;
  Navigate(this.index);
}

class ToggleNotifications extends HomeEvent {}