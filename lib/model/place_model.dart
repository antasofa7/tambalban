import 'package:equatable/equatable.dart';

class PlaceModel extends Equatable {
  final String id;
  final String name;
  final String address;
  final String openTime;
  final double latitude;
  final double longitude;
  final bool isTambalBan;
  final bool isIsiAngin;
  final bool isGantiBan;
  final String imageUrl;

  const PlaceModel({
    required this.id,
    this.name = '',
    this.address = '',
    this.openTime = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.isTambalBan = true,
    this.isIsiAngin = true,
    this.isGantiBan = true,
    this.imageUrl = '',
  });

  factory PlaceModel.fromJson(String id, Map<String, dynamic> json) =>
      PlaceModel(
        id: id,
        name: json['name'],
        address: json['address'],
        openTime: json['openTime'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        isTambalBan: json['isTambalBan'],
        isIsiAngin: json['isIsiAngin'],
        isGantiBan: json['isGantiBan'],
        imageUrl: json['imageUrl'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'openTime': openTime,
        'latitude': latitude,
        'longitude': longitude,
        'isTambalBan': isTambalBan,
        'isIsiAngin': isIsiAngin,
        'isGantiBan': isGantiBan,
        'imageUrl': imageUrl,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        openTime,
        latitude,
        longitude,
        isTambalBan,
        isIsiAngin,
        isGantiBan,
        imageUrl,
      ];
}
