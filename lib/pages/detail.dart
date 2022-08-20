import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tambal_ban/cubit/connected_cubit.dart';
import 'package:tambal_ban/pages/tracking.dart';
import 'package:tambal_ban/theme.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailPage extends StatefulWidget {
  final Map<dynamic, dynamic> place;
  const DetailPage(
    this.place, {
    Key? key,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  GoogleMapController? mapController;
  PolylinePoints polylinePoints = PolylinePoints();
  String googleApiKey = 'AIzaSyA88My8vsi2jeb9_AWZ74Fiyq_rLUJ7ezc';
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    addMarkers();
    getDirections();
    super.initState();
  }

  addMarkers() async {
    BitmapDescriptor customMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/custom-mark.png');
    String name = widget.place['items'].name;
    markers.add(Marker(
        markerId: MarkerId(widget.place['items'].latitude.toString()),
        position: LatLng(
            widget.place['items'].latitude, widget.place['items'].longitude),
        infoWindow: InfoWindow(
          title: capitalize(name),
        ),
        icon: customMarker));
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(widget.place['lat'], widget.place['long']),
        PointLatLng(
            widget.place['items'].latitude, widget.place['items'].longitude),
        travelMode: TravelMode.driving);

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }
    addPolyline(polylineCoordinates);
  }

  addPolyline(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.deepPurpleAccent,
        points: polylineCoordinates,
        width: 5);
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.place['items'].name;
    String phoneNumber = widget.place['items'].phoneNumber;

    return BlocBuilder<ConnectedCubit, ConnectedState>(
        builder: (context, state) {
      if ((state is ConnectedSuccess &&
              state.connectionType == ConnectionType.wifi) ||
          (state is ConnectedSuccess &&
              state.connectionType == ConnectionType.mobile)) {
        return Scaffold(
          backgroundColor: whiteColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                expandedHeight: 300.0,
                backgroundColor: greenColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                  widget.place['items'].imageUrl,
                                ),
                                fit: BoxFit.cover)),
                      ),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 26.0, vertical: 16.0),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                blackColor.withOpacity(0),
                                blackColor.withOpacity(0.7)
                              ])))
                    ],
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.watch_later_outlined,
                                    size: 12.0, color: whiteColor),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  widget.place['items'].openTime,
                                  style: whiteTextStyle.copyWith(
                                      fontSize: 9.0,
                                      fontWeight: medium,
                                      color: whiteColor),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Row(
                              children: [
                                Icon(Icons.near_me_outlined,
                                    size: 12.0, color: whiteColor),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                    '${widget.place['distance'].toStringAsFixed(2)} km',
                                    style: whiteTextStyle.copyWith(
                                      fontSize: 9.0,
                                      fontWeight: medium,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        capitalize(name),
                        style: whiteTextStyle.copyWith(
                            fontSize: 14.0, fontWeight: semiBold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      )
                    ],
                  ),
                  titlePadding: const EdgeInsets.all(16.0),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                            top: 26.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Layanan',
                                  style: blackTextStyle.copyWith(
                                      fontSize: 16.0, fontWeight: semiBold)),
                              SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(top: 10.0),
                                        padding: const EdgeInsets.all(10.0),
                                        width: 90.0,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2.0,
                                                color: widget
                                                        .place['items'].tubeless
                                                    ? greenColor
                                                    : grayColor),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/icon_tyre.png',
                                              width: 32.0,
                                              semanticLabel: 'icon tambal ban',
                                            ),
                                            const SizedBox(
                                              height: 4.0,
                                            ),
                                            Text('Tubeless',
                                                style: blackTextStyle.copyWith(
                                                    fontSize: 12.0,
                                                    fontWeight: medium,
                                                    color: widget.place['items']
                                                            .tubeless
                                                        ? blackColor
                                                        : grayColor)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(top: 10.0),
                                        padding: const EdgeInsets.all(10.0),
                                        width: 90.0,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2.0,
                                                color: widget
                                                        .place['items'].nitrogen
                                                    ? greenColor
                                                    : grayColor),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/icon_pump.png',
                                              width: 32.0,
                                              semanticLabel: 'icon isi angin',
                                            ),
                                            const SizedBox(
                                              height: 4.0,
                                            ),
                                            Text('Nitrogen',
                                                style: blackTextStyle.copyWith(
                                                    fontSize: 12.0,
                                                    fontWeight: medium,
                                                    color: widget.place['items']
                                                            .nitrogen
                                                        ? blackColor
                                                        : grayColor)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(top: 10.0),
                                        padding: const EdgeInsets.all(10.0),
                                        width: 90.0,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2.0,
                                                color: widget
                                                        .place['items'].gantiBan
                                                    ? greenColor
                                                    : grayColor),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/icon_change.png',
                                              width: 32.0,
                                              semanticLabel: 'icon ganti ban',
                                            ),
                                            const SizedBox(
                                              height: 4.0,
                                            ),
                                            Text('Ganti ban',
                                                style: blackTextStyle.copyWith(
                                                    fontSize: 12.0,
                                                    fontWeight: medium,
                                                    color: widget.place['items']
                                                            .gantiBan
                                                        ? blackColor
                                                        : grayColor)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ))
                            ],
                          )),
                      Container(
                          margin:
                              const EdgeInsets.only(top: 24.0, bottom: 16.0),
                          width: double.infinity,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Lokasi',
                                    style: blackTextStyle.copyWith(
                                        fontSize: 16.0, fontWeight: semiBold)),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: greenColor,
                                    ),
                                    const SizedBox(
                                      width: 4.0,
                                    ),
                                    Flexible(
                                      child: Text(
                                        capitalize(
                                            widget.place['items'].address),
                                        style: blackTextStyle,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 300.0,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: GoogleMap(
                                    onMapCreated: _onMapCreated,
                                    myLocationEnabled: true,
                                    liteModeEnabled: true,
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                            widget.place['items'].latitude,
                                            widget.place['items'].longitude),
                                        zoom: 12.0),
                                    markers: markers,
                                    polylines:
                                        Set<Polyline>.of(polylines.values),
                                    mapType: MapType.normal,
                                  ),
                                ),
                              ])),
                    ],
                  ),
                ),
              )
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextButton.icon(
                    onPressed: phoneNumber[0] == '0' || phoneNumber[0] == '+'
                        ? () async {
                            var firstLetter = phoneNumber[0];
                            var idPhoneCode = firstLetter == '0'
                                ? phoneNumber.replaceFirst(firstLetter, '+62')
                                : phoneNumber;
                            var urlWhatsapp =
                                "whatsapp://send?phone=$idPhoneCode";
                            if (Platform.isAndroid) {
                              await launchUrlString(urlWhatsapp);
                            }
                          }
                        : null,
                    style: TextButton.styleFrom(
                      elevation: 5,
                      fixedSize: const Size(double.infinity, 50.0),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30))),
                      backgroundColor:
                          phoneNumber[0] == '0' || phoneNumber[0] == '+'
                              ? greenColor
                              : grayColor.withOpacity(0.8),
                    ),
                    label: Column(
                      children: [
                        Text(
                          'Whatsapp',
                          style: whiteTextStyle,
                        ),
                        Text(
                          phoneNumber,
                          style: whiteTextStyle.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    icon: Icon(
                      Icons.whatsapp_outlined,
                      color: whiteColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TrackingPage(widget.place)));
                    },
                    style: TextButton.styleFrom(
                      elevation: 5,
                      fixedSize: const Size(double.infinity, 50.0),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30))),
                      backgroundColor: greenColor,
                    ),
                    label: Text(
                      'Telusuri',
                      style: whiteTextStyle,
                    ),
                    icon: RotationTransition(
                        turns: const AlwaysStoppedAnimation(40 / 360),
                        child: Icon(
                          Icons.navigation_rounded,
                          color: whiteColor,
                        )),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Scaffold(
        backgroundColor: whiteColor,
        body: Center(
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
                  context.read<ConnectedCubit>().connectivityStreamSubcription;
                },
                child: Text('Muat Ulang', style: whiteTextStyle),
                style: TextButton.styleFrom(backgroundColor: greenColor)),
          ],
        )),
      );
    });
  }
}
