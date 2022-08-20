import 'package:equatable/equatable.dart';

class PlaceModel extends Equatable {
  final String id;
  final String name;
  final String address;
  final String openTime;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final bool tubeless;
  final bool nitrogen;
  final bool gantiBan;
  final String imageUrl;

  const PlaceModel({
    required this.id,
    this.name = '',
    this.address = '',
    this.openTime = '',
    this.phoneNumber = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.tubeless = true,
    this.nitrogen = true,
    this.gantiBan = true,
    this.imageUrl = '',
  });

  factory PlaceModel.fromJson(String id, Map<String, dynamic> json) =>
      PlaceModel(
        id: id,
        name: json['name'],
        address: json['address'],
        openTime: json['openTime'],
        phoneNumber: json['phoneNumber'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        tubeless: json['tubeless'],
        nitrogen: json['nitrogen'],
        gantiBan: json['gantiBan'],
        imageUrl: json['imageUrl'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'openTime': openTime,
        'phoneNumber': phoneNumber,
        'latitude': latitude,
        'longitude': longitude,
        'tubeless': tubeless,
        'nitrogen': nitrogen,
        'gantiBan': gantiBan,
        'imageUrl': imageUrl,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        openTime,
        phoneNumber,
        latitude,
        longitude,
        tubeless,
        nitrogen,
        gantiBan,
        imageUrl,
      ];
}
