



import 'package:equatable/equatable.dart';

import '../../models/place_model.dart';


abstract class HomeState extends Equatable {
  final List<PlaceModel>? places;
  const HomeState({this.places});

  @override
  List<Object?> get props => [places];
}

class HomeInitial extends HomeState {
  const HomeInitial() : super(places: null);
}

class HomeLoading extends HomeState {
  const HomeLoading() : super(places: null);
}

class HomeSuccess extends HomeState {
  const HomeSuccess(List<PlaceModel> places) : super(places: places);
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message) : super(places: null);

  @override
  List<Object?> get props => [message, places];
}