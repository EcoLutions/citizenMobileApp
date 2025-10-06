import 'package:equatable/equatable.dart';

class Municipality extends Equatable {
  final String id;
  final String name;

  const Municipality({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}