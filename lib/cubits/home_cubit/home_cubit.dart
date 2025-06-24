


import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/place_model.dart';
import 'home_state.dart';





class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(HomeState(places: [
    PlaceModel(id: 1, status: 'Empty', plateNumber: null),
    PlaceModel(id: 2, status: 'Busy', plateNumber: 'XYZ789'),
    PlaceModel(id: 3, status: 'Booked', plateNumber: 'ABC123'),
    PlaceModel(id: 4, status: 'Empty', plateNumber: null),
    PlaceModel(id: 5, status: 'Empty', plateNumber: null),
    PlaceModel(id: 6, status: 'Busy', plateNumber: 'DEF456'),
  ]));

  void reservePlace(int id, String plateNumber) {
    final updatedPlaces = state.places.map((place) {
      if (place.id == id) {
        return PlaceModel(id: id, status: 'Booked', plateNumber: plateNumber);
      }
      return place;
    }).toList();
    emit(state.copyWith(places: updatedPlaces));
  }
}