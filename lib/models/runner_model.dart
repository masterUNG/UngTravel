import 'dart:convert';

class RunnerModel {
  final String id;
  final String idUser;
  final String dateRunner;
  final String timeRunner;
  final String distance;
  final String listLat;
  final String listLng;
  RunnerModel({
     this.id,
     this.idUser,
     this.dateRunner,
     this.timeRunner,
     this.distance,
     this.listLat,
     this.listLng,
  });

  RunnerModel copyWith({
    String id,
    String idUser,
    String dateRunner,
    String timeRunner,
    String distance,
    String listLat,
    String listLng,
  }) {
    return RunnerModel(
      id: id ?? this.id,
      idUser: idUser ?? this.idUser,
      dateRunner: dateRunner ?? this.dateRunner,
      timeRunner: timeRunner ?? this.timeRunner,
      distance: distance ?? this.distance,
      listLat: listLat ?? this.listLat,
      listLng: listLng ?? this.listLng,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUser': idUser,
      'dateRunner': dateRunner,
      'timeRunner': timeRunner,
      'distance': distance,
      'listLat': listLat,
      'listLng': listLng,
    };
  }

  factory RunnerModel.fromMap(Map<String, dynamic> map) {
    return RunnerModel(
      id: map['id'],
      idUser: map['idUser'],
      dateRunner: map['dateRunner'],
      timeRunner: map['timeRunner'],
      distance: map['distance'],
      listLat: map['listLat'],
      listLng: map['listLng'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RunnerModel.fromJson(String source) => RunnerModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RunnerModel(id: $id, idUser: $idUser, dateRunner: $dateRunner, timeRunner: $timeRunner, distance: $distance, listLat: $listLat, listLng: $listLng)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is RunnerModel &&
      other.id == id &&
      other.idUser == idUser &&
      other.dateRunner == dateRunner &&
      other.timeRunner == timeRunner &&
      other.distance == distance &&
      other.listLat == listLat &&
      other.listLng == listLng;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      idUser.hashCode ^
      dateRunner.hashCode ^
      timeRunner.hashCode ^
      distance.hashCode ^
      listLat.hashCode ^
      listLng.hashCode;
  }
}
