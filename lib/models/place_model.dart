

class PlaceModel {
  final int id;
  final String status; // "Empty" or "Busy"
  final String? plateNumber;

  PlaceModel({required this.id, required this.status, this.plateNumber});

  // Factory to create from JSON (if needed later)
  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'],
      status: json['status'],
      plateNumber: json['plateNumber'],
    );
  }

  // CopyWith for immutability
  PlaceModel copyWith({int? id, String? status}) {
    return PlaceModel(
      id: id ?? this.id,
      status: status ?? this.status,
      plateNumber: plateNumber,
    );
  }
}

