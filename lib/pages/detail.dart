import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tambal_ban/model/tire_patch_place.dart';
import 'package:tambal_ban/pages/tracking.dart';
import 'package:tambal_ban/theme.dart';

class DetailPage extends StatefulWidget {
  final TirePatchPlace place;
  final String distance;
  final double latitude;
  final double longitude;
  const DetailPage(
      {Key? key,
      required this.place,
      required this.distance,
      required this.latitude,
      required this.longitude})
      : super(key: key);

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
    markers.add(Marker(
        markerId: MarkerId(widget.place.latitude.toString()),
        position: LatLng(widget.place.latitude, widget.place.longitude),
        infoWindow: InfoWindow(
          title: widget.place.name,
        ),
        icon: BitmapDescriptor.defaultMarker));
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(widget.latitude, widget.longitude),
        PointLatLng(widget.place.latitude, widget.place.longitude),
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
    final String isOpen = widget.place.isOpen ? 'Buka' : 'Tutup';

    return Scaffold(
      backgroundColor: whiteColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              widget.place.imageAsset,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: whiteColor,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: blackColor,
                          )),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.watch_later_outlined,
                                      size: 12.0,
                                      color: widget.place.isOpen
                                          ? greenColor
                                          : whiteColor),
                                  const SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(
                                    isOpen,
                                    style: whiteTextStyle.copyWith(
                                        fontSize: 10.0,
                                        fontWeight: medium,
                                        color: widget.place.isOpen
                                            ? greenColor
                                            : whiteColor),
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
                                  Text('${widget.distance} km',
                                      style: whiteTextStyle.copyWith(
                                        fontSize: 10.0,
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
                        Text(widget.place.name,
                            style: whiteTextStyle.copyWith(
                                fontSize: 14.0, fontWeight: semiBold))
                      ],
                    ),
                  ]),
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
                      margin: const EdgeInsets.only(top: 26.0),
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
                                    margin: const EdgeInsets.only(top: 10.0),
                                    padding: const EdgeInsets.all(10.0),
                                    width: 90.0,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2.0,
                                            color: widget.place.tambalBan
                                                ? greenColor
                                                : grayColor),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icon_tyre.png',
                                          width: 32.0,
                                        ),
                                        const SizedBox(
                                          height: 4.0,
                                        ),
                                        Text('Tambal ban',
                                            style: blackTextStyle.copyWith(
                                                fontSize: 10.0,
                                                fontWeight: medium,
                                                color: widget.place.tambalBan
                                                    ? greenColor
                                                    : grayColor)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    padding: const EdgeInsets.all(10.0),
                                    width: 90.0,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2.0,
                                            color: widget.place.tambalBan
                                                ? greenColor
                                                : grayColor),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icon_pump.png',
                                          width: 32.0,
                                        ),
                                        const SizedBox(
                                          height: 4.0,
                                        ),
                                        Text('Isi angin',
                                            style: blackTextStyle.copyWith(
                                                fontSize: 10.0,
                                                fontWeight: medium,
                                                color: widget.place.tambalBan
                                                    ? greenColor
                                                    : grayColor)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    padding: const EdgeInsets.all(10.0),
                                    width: 90.0,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2.0,
                                            color: widget.place.gantiBan
                                                ? greenColor
                                                : grayColor),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icon_change.png',
                                          width: 32.0,
                                        ),
                                        const SizedBox(
                                          height: 4.0,
                                        ),
                                        Text('Ganti ban',
                                            style: blackTextStyle.copyWith(
                                                fontSize: 10.0,
                                                fontWeight: medium,
                                                color: widget.place.gantiBan
                                                    ? greenColor
                                                    : grayColor)),
                                      ],
                                    ),
                                  )
                                ],
                              ))
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.only(top: 24.0, bottom: 16.0),
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
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: greenColor,
                                  size: 18.0,
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  widget.place.location,
                                  style: blackTextStyle,
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
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: GoogleMap(
                                onMapCreated: _onMapCreated,
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                zoomControlsEnabled: false,
                                zoomGesturesEnabled: true,
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(widget.place.latitude,
                                        widget.place.longitude),
                                    zoom: 12.0),
                                markers: markers,
                                polylines: Set<Polyline>.of(polylines.values),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrackingPage(
                    place: widget.place,
                    distance: widget.distance,
                    latitude: widget.latitude,
                    longitude: widget.longitude),
              ));
        },
        backgroundColor: greenColor,
        child: Container(
          width: 90.0,
          height: 90.0,
          decoration: BoxDecoration(
            color: greenColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(40 / 360),
            child: Icon(
              Icons.navigation,
              size: 32.0,
              color: whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
