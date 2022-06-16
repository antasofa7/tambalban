import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tambal_ban/model/tire_patch_place.dart';
import 'package:tambal_ban/theme.dart';
import 'package:tambal_ban/widgets/tire_pacth_place_grid.dart';

import '../widgets/tire_pacth_place_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? position;
  double lat = 0, long = 0;
  StreamSubscription<Position>? positionStream;
  GoogleMapController? mapController;
  Iterable markers = [];
  LatLng _center = const LatLng(-6.907731, 109.730173);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    lat = position!.latitude;
    long = position!.longitude;

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {});
    lat = position!.latitude;
    long = position!.longitude;

    setState(() {
      _center = LatLng(position!.latitude, position!.longitude);
    });

    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _center,
      zoom: 15.0,
    )));

    getMarkers();
  }

  getMarkers() {
    Iterable _markers = Iterable.generate(tirePatchPlaceList.length, (index) {
      TirePatchPlace places = tirePatchPlaceList[index];
      String isOpen = places.isOpen ? 'Buka' : 'Tutup';
      return Marker(
          markerId: MarkerId(places.location),
          position: LatLng(
            places.latitude,
            places.longitude,
          ),
          infoWindow: InfoWindow(
              title: places.name,
              snippet: isOpen,
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (builder) {
                      return Container(
                        height: 280.0,
                        padding: const EdgeInsets.all(
                          24.0,
                        ),
                        color: whiteColor,
                        child: TirePatchPlaceGrid(
                            place: places, latitude: lat, longitude: long),
                      );
                    });
              }),
          icon: BitmapDescriptor.defaultMarker);
    });

    setState(() {
      markers = _markers;
    });
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget map() {
      return GoogleMap(
        myLocationEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 12.0),
        markers: Set.from(markers),
        mapType: MapType.normal,
      );
    }

    Widget searchInput() {
      return InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/search');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Container(
            margin: const EdgeInsets.only(top: 100.0),
            height: 50.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                      color: whiteColor.withOpacity(0.8),
                      offset: const Offset(0, 20),
                      blurRadius: 40.0)
                ]),
            child: Row(
              children: [
                Expanded(
                    child: Text('Cari tempat tambal ban...',
                        style: grayTextStyle.copyWith(
                            fontSize: 16.0, fontWeight: light))),
                Icon(
                  Icons.search_outlined,
                  color: blackColor,
                  size: 28.0,
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget nearestPlace() {
      return SizedBox.expand(
        child: DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.3,
          maxChildSize: 0.75,
          builder: (context, scrollController) {
            return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                        color: whiteColor.withOpacity(0.5),
                        offset: const Offset(0, 20),
                        blurRadius: 40.0)
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 4.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                              color: grayColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(2.0)),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        'Tambal ban terdekat',
                        style: blackTextStyle.copyWith(fontSize: 18.0),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: tirePatchPlaceList.length,
                          itemBuilder: (context, index) {
                            TirePatchPlace place = tirePatchPlaceList[index];
                            return TirePatchPlaceList(
                                place: place, latitude: lat, longitude: long);
                          },
                        ),
                      ),
                    ]));
          },
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          map(),
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  greenColor,
                  greenColor.withOpacity(0.5),
                  greenColor.withOpacity(0),
                ])),
          ),
          searchInput(),
          nearestPlace()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.location_searching,
          color: Colors.white,
        ),
        backgroundColor: greenColor,
        onPressed: () {
          getLocation();
        },
      ),
    );
  }
}
