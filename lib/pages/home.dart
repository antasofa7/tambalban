import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tambal_ban/cubit/place_cubit.dart';
import 'package:tambal_ban/model/place_model.dart';
import 'package:tambal_ban/pages/detail.dart';
import 'package:tambal_ban/theme.dart';

import '../widgets/place_list.dart';

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
  LatLng center = const LatLng(-6.907731, 109.730173);
  double distanceInMeters = 0.0;

  void onMapCreated(GoogleMapController controller) {
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
      center = LatLng(position!.latitude, position!.longitude);
    });

    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: center,
      zoom: 15.0,
    )));
  }

  List<Map> sortByDistance(List<PlaceModel> places) {
    List<Map<dynamic, dynamic>> placesWithdistance = [];

    for (var place in places) {
      distanceInMeters = Geolocator.distanceBetween(
              lat, long, place.latitude, place.longitude) /
          1000;

      placesWithdistance.add({
        'items': place,
        'distance': distanceInMeters,
        'lat': lat,
        'long': long
      });
    }

    placesWithdistance.sort((a, b) => a['distance'].compareTo(b['distance']));

    return placesWithdistance;
  }

  @override
  void initState() {
    context.read<PlaceCubit>().fetchPlaces();
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future bottomSheet(List<PlaceModel> places, int index) {
      var sort = sortByDistance(places);
      return showModalBottomSheet(
          context: context,
          builder: (builder) {
            return Container(
              height: 300.0,
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              color: whiteColor,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                          color: blackColor.withOpacity(0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 20))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8)),
                      child: Image.network(
                        sort[index]['items'].imageUrl,
                        fit: BoxFit.cover,
                        semanticLabel: sort[index]['items'].name,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              capitalize(sort[index]['items'].name),
                              maxLines: 1,
                              style: blackTextStyle.copyWith(
                                fontSize: 16.0,
                                fontWeight: semiBold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              capitalize(sort[index]['items'].address),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: grayTextStyle.copyWith(fontSize: 12.0),
                            ),
                            const SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.watch_later_outlined,
                                            size: 16.0, color: greenColor),
                                        const SizedBox(
                                          width: 4.0,
                                        ),
                                        Text(
                                          sort[index]['items'].openTime,
                                          style: grayTextStyle.copyWith(
                                              fontSize: 12.0,
                                              color: greenColor),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.near_me_outlined,
                                            size: 16.0, color: grayColor),
                                        const SizedBox(
                                          width: 4.0,
                                        ),
                                        Text(
                                            '${sort[index]['distance'].toStringAsFixed(2)} km',
                                            style: grayTextStyle.copyWith(
                                              fontSize: 12.0,
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailPage(sort[index]),
                                          ));
                                    },
                                    style: TextButton.styleFrom(
                                        backgroundColor: greenColor,
                                        fixedSize: const Size(100.0, 32.0)),
                                    child: Text(
                                      'Lihat Detail',
                                      style: whiteTextStyle.copyWith(
                                          fontSize: 12.0),
                                    )),
                              ],
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    Widget map(List<PlaceModel> places) {
      var sort = sortByDistance(places);
      Iterable _markers = Iterable.generate(sort.length, (index) {
        return Marker(
            markerId: MarkerId(sort[index]['items'].name),
            position: LatLng(
              sort[index]['items'].latitude,
              sort[index]['items'].longitude,
            ),
            flat: true,
            infoWindow: InfoWindow(
                title: capitalize(sort[index]['items'].name),
                snippet: sort[index]['items'].openTime,
                onTap: () {
                  bottomSheet(places, index);
                }),
            icon: BitmapDescriptor.defaultMarker);
      });

      return GoogleMap(
        myLocationEnabled: true,
        onMapCreated: onMapCreated,
        initialCameraPosition: CameraPosition(target: center, zoom: 12.0),
        markers: Set.from(_markers),
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

    Widget nearestPlace(List<PlaceModel> places) {
      var sort = sortByDistance(places);
      return SizedBox.expand(
        child: DraggableScrollableSheet(
          initialChildSize: 0.35,
          minChildSize: 0.125,
          maxChildSize: 0.75,
          builder: (context, scrollController) {
            return Container(
                padding:
                    const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0),
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
                      const SizedBox(
                        height: 12.0,
                      ),
                      sort[0]['distance'] < 20
                          ? Expanded(
                              child: ListView.builder(
                                controller: scrollController,
                                shrinkWrap: true,
                                itemCount: sort.length < 20 ? sort.length : 20,
                                itemBuilder: (context, index) {
                                  return sort[index]['distance'] < 20
                                      ? PlaceList(
                                          sort[index],
                                          onPressed: () {
                                            setState(() {
                                              center = LatLng(
                                                  sort[index]['items'].latitude,
                                                  sort[index]['items']
                                                      .longitude);
                                            });
                                            mapController?.animateCamera(
                                                CameraUpdate.newCameraPosition(
                                                    CameraPosition(
                                              target: center,
                                              zoom: 14.0,
                                            )));
                                            bottomSheet(places, index);
                                          },
                                        )
                                      : const SizedBox();
                                },
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.only(top: 24.0),
                              child: Column(children: [
                                Text(
                                  'Maaf, belum ada data lokasi tambal ban di dekat Anda!',
                                  style: grayTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/addPlace');
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: greenColor,
                                      minimumSize: const Size(180, 40),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0))),
                                  child: Text(
                                    'Tambah Tambal Ban',
                                    style: whiteTextStyle,
                                  ),
                                )
                              ]),
                            ),
                    ]));
          },
        ),
      );
    }

    return BlocConsumer<PlaceCubit, PlaceState>(
      listener: (context, state) {
        if (state is PlaceFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                state.error,
                style: whiteTextStyle,
              )));
        } else if (state is PlaceLoading) {
          const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      builder: (context, state) {
        if (state is PlaceSuccess) {
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  map(state.places),
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
                  nearestPlace(state.places)
                ],
              ),
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
        return const SizedBox();
      },
    );
  }
}
