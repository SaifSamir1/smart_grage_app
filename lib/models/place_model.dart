


import 'package:equatable/equatable.dart';

// Define Status enum outside the class
enum Status {
  empty,
  busy,
  booked,
}

class PlaceModel extends Equatable {
  final int id;
  final Status status; // Using the external enum
  final String? plateNumber;

  PlaceModel({required this.id, required this.status, this.plateNumber});

  // Factory to create from JSON (matching MQTT format)
  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: int.parse(json['place_id'].replaceAll('Place', '')),
      status: Status.values.firstWhere(
            (s) => s.toString().split('.').last == json['status'].toString().toLowerCase(),
        orElse: () => Status.empty, // Default to empty if invalid
      ),
      plateNumber: json['plate_number'],
    );
  }

  // Convert to JSON for potential future sending
  Map<String, dynamic> toJson() {
    return {
      'place_id': 'Place$id',
      'status': status.toString().split('.').last,
      'plate_number': plateNumber,
    };
  }

  // CopyWith with full support for immutability
  PlaceModel copyWith({int? id, Status? status, String? plateNumber}) {
    return PlaceModel(
      id: id ?? this.id,
      status: status ?? this.status,
      plateNumber: plateNumber ?? this.plateNumber,
    );
  }

  @override
  List<Object?> get props => [id, status, plateNumber];
}