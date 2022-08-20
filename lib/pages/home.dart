import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tambal_ban/ad_helper.dart';
import 'package:tambal_ban/cubit/connected_cubit.dart';
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
  bool isLoading = false;
  Position? position;
  double lat = 0, long = 0;
  StreamSubscription<Position>? positionStream;
  GoogleMapController? mapController;
  LatLng center = const LatLng(-6.907731, 109.730173);
  double distanceInMeters = 0.0;
  Iterable markers = {};
  BannerAd? _bannerAd;

  _initBannerAd() {
    BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _bannerAd = ad as BannerAd;
            });
          },
          onAdFailedToLoad: (ad, err) {
            print('Failed to load a banner ad: ${err.message}');
            ad.dispose();
          },
        )).load();
  }

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
      if (position == null) {
        isLoading = true;
      } else {
        center = LatLng(position!.latitude, position!.longitude);
      }
    });

    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: center,
      zoom: 15.0,
    )));
  }

  addMarkers(state, bottomSheet) async {
    List<PlaceModel> places = state.places;
    var sort = sortByDistance(places);
    BitmapDescriptor customMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/custom-mark.png');
    markers = Iterable.generate(sort.length, (index) {
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
                bottomSheet(
                  state,
                  index,
                );
              }),
          icon: customMarker);
    });
  }

  List<Map> sortByDistance(List<PlaceModel> places) {
    List<Map<dynamic, dynamic>> placesWithdistance = [];

    if (places.isNotEmpty) {
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
    } else {
      print('Data not found');
    }

    placesWithdistance.sort((a, b) => a['distance'].compareTo(b['distance']));

    return placesWithdistance;
  }

  @override
  void initState() {
    context.read<PlaceCubit>().fetchPlaces();
    getLocation();
    _initBannerAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future bottomSheet(state, int index) {
      List<PlaceModel> places = state.places;
      var sort = sortByDistance(places);
      return showModalBottomSheet(
          context: context,
          builder: (builder) {
            return state is PlaceLoading
                ? Shimmer.fromColors(
                    baseColor: grayColor.withOpacity(0.5),
                    highlightColor: grayColor.withOpacity(0.1),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 300.0,
                          decoration: BoxDecoration(
                              color: grayColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          width: double.infinity,
                          height: 80.0,
                          decoration: BoxDecoration(
                              color: grayColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: 300.0,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
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
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0)),
                              child: Image.network(
                                sort[index]['items'].imageUrl,
                                scale: 1.4,
                                fit: BoxFit.cover,
                                semanticLabel: sort[index]['items'].name,
                              ),
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
                                    style:
                                        grayTextStyle.copyWith(fontSize: 12.0),
                                  ),
                                  const SizedBox(
                                    height: 6.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.watch_later_outlined,
                                                  size: 16.0,
                                                  color: greenColor),
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
                                              fixedSize:
                                                  const Size(100.0, 32.0)),
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

    Widget map() {
      return BlocConsumer<PlaceCubit, PlaceState>(
        listener: (context, state) {
          if (state is PlaceFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  state.error,
                  style: whiteTextStyle,
                )));
          }
        },
        builder: (context, state) {
          if (state is PlaceLoading) {
            return SizedBox(
                child: Shimmer.fromColors(
              baseColor: grayColor.withOpacity(0.5),
              highlightColor: grayColor.withOpacity(0.1),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        color: grayColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                ],
              ),
            ));
          } else if (state is PlaceSuccess) {
            addMarkers(state, bottomSheet);
          }
          return GoogleMap(
            myLocationEnabled: true,
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(target: center, zoom: 12.0),
            markers: Set.from(markers),
            mapType: MapType.normal,
          );
        },
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
                      color: whiteColor.withOpacity(0.5),
                      offset: const Offset(0, 10),
                      blurRadius: 20.0)
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
          minChildSize: 0.15,
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
                      BlocConsumer<PlaceCubit, PlaceState>(
                          listener: (context, state) {
                        if (state is PlaceFailed) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                state.error,
                                style: whiteTextStyle,
                              )));
                        }
                      }, builder: (context, state) {
                        if (state is PlaceLoading) {
                          return SizedBox(
                              child: Shimmer.fromColors(
                            baseColor: grayColor.withOpacity(0.5),
                            highlightColor: grayColor.withOpacity(0.1),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                      color: grayColor.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8.0)),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                      color: grayColor.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8.0)),
                                ),
                              ],
                            ),
                          ));
                        } else if (state is PlaceSuccess) {
                          List<PlaceModel> places = state.places;
                          var sort = sortByDistance(places);
                          return sort.isEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(
                                    'Belum ada data lokasi tambal ban!',
                                    style: blackTextStyle.copyWith(
                                        fontWeight: medium, fontSize: 16.0),
                                    textAlign: TextAlign.center,
                                  ))
                              : sort[0]['distance'] < 20
                                  ? Expanded(
                                      child: ListView.builder(
                                        controller: scrollController,
                                        shrinkWrap: true,
                                        itemCount:
                                            sort.length < 20 ? sort.length : 20,
                                        itemBuilder: (context, index) {
                                          return sort[index]['distance'] < 20
                                              ? PlaceList(
                                                  sort[index],
                                                  onPressed: () {
                                                    setState(() {
                                                      center = LatLng(
                                                          sort[index]['items']
                                                              .latitude,
                                                          sort[index]['items']
                                                              .longitude);
                                                    });
                                                    mapController?.animateCamera(
                                                        CameraUpdate
                                                            .newCameraPosition(
                                                                CameraPosition(
                                                      target: center,
                                                      zoom: 14.0,
                                                    )));
                                                    bottomSheet(state, index);
                                                  },
                                                )
                                              : const SizedBox();
                                        },
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(children: [
                                        Text(
                                          'Belum ada data lokasi tambal ban terdekat!',
                                          style: blackTextStyle.copyWith(
                                              fontWeight: medium,
                                              fontSize: 16.0),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(
                                          'Tambahkan data lokasi tambal ban di sekitar Anda!',
                                          style: grayTextStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/add-place');
                                          },
                                          style: TextButton.styleFrom(
                                              backgroundColor: greenColor,
                                              minimumSize: const Size(180, 40),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0))),
                                          child: Text(
                                            'Tambah Tambal Ban',
                                            style: whiteTextStyle,
                                          ),
                                        )
                                      ]),
                                    );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      })
                    ]));
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      body: BlocBuilder<ConnectedCubit, ConnectedState>(
        builder: (context, state) {
          if ((state is ConnectedSuccess &&
                  state.connectionType == ConnectionType.wifi) ||
              (state is ConnectedSuccess &&
                  state.connectionType == ConnectionType.mobile)) {
            return Stack(
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
                nearestPlace(),
                // display bannerAds when ready
                if (_bannerAd != null)
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                  )
              ],
            );
          } else if (state is ConnectedFailed) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Internet tidak terhubung',
                  style: blackTextStyle,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                TextButton(
                    onPressed: () {
                      context
                          .read<ConnectedCubit>()
                          .connectivityStreamSubcription;
                    },
                    child: Text('Muat Ulang', style: whiteTextStyle),
                    style: TextButton.styleFrom(backgroundColor: greenColor)),
              ],
            ));
          }
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Internet tidak terhubung',
                style: blackTextStyle,
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextButton(
                  onPressed: () {
                    context
                        .read<ConnectedCubit>()
                        .connectivityStreamSubcription;
                  },
                  child: Text('Muat Ulang', style: whiteTextStyle),
                  style: TextButton.styleFrom(backgroundColor: greenColor)),
            ],
          ));
        },
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
