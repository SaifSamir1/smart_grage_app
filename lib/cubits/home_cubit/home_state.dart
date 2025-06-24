



import '../../models/place_model.dart';

class HomeState {
  final List<PlaceModel> places;

  HomeState({required this.places});

  HomeState copyWith({List<PlaceModel>? places}) {
    return HomeState(places: places ?? this.places);
  }
}