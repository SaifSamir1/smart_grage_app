import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/place_model.dart';
import '../../services/mqtt_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final MqttRepository mqttRepository;
  List<PlaceModel> places = List.generate(
    6,
    (index) =>
        PlaceModel(id: index + 1, status: Status.empty, plateNumber: null),
  );

  HomeCubit(this.mqttRepository) : super(HomeInitial()) {
    _initialize();
  }

  void _initialize() async {
    emit(HomeLoading());
    try {
      await mqttRepository.connect();
      mqttRepository.subscribeToStatusUpdates(this);
      await fetchPlaces();
    } catch (e) {
      emit(HomeError('Failed to initialize MQTT: $e'));
    }
  }

  Future<void> fetchPlaces() async {
    emit(HomeLoading());
    try {
      final initialData = await mqttRepository.getInitialState();

      for (var data in initialData) {
        final placeNum = int.parse(data['place_id'].replaceAll('Place', ''));
        final index = places.indexWhere((p) => p.id == placeNum);

        if (index != -1) {
          places[index] = PlaceModel(
            id: placeNum,
            status: Status.values.firstWhere(
              (s) =>
                  s.toString().split('.').last == data['status'].toLowerCase(),
              orElse: () => Status.empty,
            ),
            plateNumber:
                data['plate_number']?.isNotEmpty == true
                    ? data['plate_number']
                    : null,
          );
        }
      }

      emit(HomeSuccess(List<PlaceModel>.from(places)));
    } catch (e) {
      emit(HomeError('Failed to fetch places: $e'));
    }
  }

  void bookPlace(int placeId, String plateNumber) {
    try {
      mqttRepository.publishReservation(placeId, plateNumber);
      // State update will be handled by subscribeToStatusUpdates
    } catch (e) {
      emit(HomeError('Failed to book place: $e'));
    }
  }

  void updatePlaceStatus(String placeId, String status, String plateNumber) {
    final placeNum = int.parse(placeId.replaceAll('Place', ''));
    final updatedPlaces =
        places.map((place) {
          if (place.id == placeNum) {
            return PlaceModel(
              id: place.id,
              status: Status.values.firstWhere(
                (s) => s.toString().split('.').last == status.toLowerCase(),
                orElse: () => Status.empty,
              ),
              plateNumber: plateNumber.isEmpty ? null : plateNumber,
            );
          }
          return place;
        }).toList();
    places = updatedPlaces;
    emit(HomeSuccess(updatedPlaces));
  }

  void disconnect() {
    mqttRepository.disconnect();
    emit(HomeInitial());
  }
}
