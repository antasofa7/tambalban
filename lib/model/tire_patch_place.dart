class TirePatchPlace {
  String name;
  String location;
  bool isOpen;
  double latitude;
  double longitude;
  String imageAsset;
  bool tambalBan;
  bool isiAngin;
  bool gantiBan;

  TirePatchPlace({
    required this.name,
    required this.location,
    required this.isOpen,
    required this.latitude,
    required this.longitude,
    required this.imageAsset,
    required this.tambalBan,
    required this.isiAngin,
    required this.gantiBan,
  });

  void map(Null Function(dynamic place) param0) {}
}

var tirePatchPlaceList = [
  TirePatchPlace(
      name: 'Tambal Ban Sentosa',
      location: 'Jalan A. Yani',
      isOpen: true,
      latitude: -6.902479,
      longitude: 109.731922,
      imageAsset: 'assets/place-image-1.png',
      tambalBan: true,
      isiAngin: true,
      gantiBan: true),
  TirePatchPlace(
    name: 'Tambal Ban Subur',
    location: 'Jalan Jend. Sudirman',
    isOpen: true,
    latitude: -6.898980,
    longitude: 109.731532,
    imageAsset: 'assets/place-image-2.png',
    tambalBan: true,
    isiAngin: true,
    gantiBan: false,
  ),
  TirePatchPlace(
      name: 'Tambal Ban Giwang',
      location: 'Jalan RE Martadinata',
      isOpen: true,
      latitude: -6.934450,
      longitude: 109.721376,
      imageAsset: 'assets/place-image-3.png',
      tambalBan: true,
      isiAngin: true,
      gantiBan: true),
  TirePatchPlace(
      name: 'Tambal Ban Lancar Rejeki',
      location: 'Jalan H. Agus Salim',
      isOpen: false,
      latitude: -6.911921,
      longitude: 109.741385,
      imageAsset: 'assets/place-image-4.png',
      tambalBan: true,
      isiAngin: true,
      gantiBan: true),
  TirePatchPlace(
      name: 'Tambal Ban Berkah Ban',
      location: 'Jalan Gajah Mada',
      isOpen: true,
      latitude: -6.954400,
      longitude: 109.676739,
      imageAsset: 'assets/place-image-5.png',
      tambalBan: true,
      isiAngin: true,
      gantiBan: true),
  TirePatchPlace(
      name: 'Tambal Ban Sindung Jaya',
      location: 'Jalan Yos Sudarso',
      isOpen: false,
      latitude: -6.898168,
      longitude: 109.776510,
      imageAsset: 'assets/place-image-6.png',
      tambalBan: true,
      isiAngin: true,
      gantiBan: false),
  TirePatchPlace(
      name: 'Tambal Ban Tip Top',
      location: 'Jalan Hos Cokroaminoto',
      isOpen: true,
      latitude: -6.923094,
      longitude: 109.728455,
      imageAsset: 'assets/place-image-7.png',
      tambalBan: true,
      isiAngin: true,
      gantiBan: true),
  TirePatchPlace(
      name: 'Tambal Ban Mukorobin',
      location: 'Jalan Otto Iskandardinata',
      isOpen: false,
      latitude: -6.918968,
      longitude: 109.706435,
      imageAsset: 'assets/place-image-8.png',
      tambalBan: true,
      isiAngin: true,
      gantiBan: true),
  TirePatchPlace(
      name: 'Tambal Ban YTS',
      location: 'Jalan Otto Iskandardinata',
      isOpen: true,
      latitude: -6.894715,
      longitude: 109.694587,
      imageAsset: 'assets/place-image-9.png',
      tambalBan: true,
      isiAngin: true,
      gantiBan: true),
  TirePatchPlace(
      name: 'Tambal Ban Pak Slamet',
      location: 'Jalan KH. Mas Mansur',
      isOpen: false,
      latitude: -6.937209,
      longitude: 109.746358,
      imageAsset: 'assets/place-image-10.png',
      tambalBan: true,
      isiAngin: true,
      gantiBan: false),
];
