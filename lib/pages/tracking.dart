import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tambal_ban/model/tire_patch_place.dart';
import 'package:tambal_ban/theme.dart';

class TrackingPage extends StatefulWidget {
  final TirePatchPlace place;
  final String distance;
  final double latitude;
  final double longitude;
  const TrackingPage(
      {Key? key,
      required this.place,
      required this.distance,
      required this.latitude,
      required this.longitude})
      : super(key: key);

  @override
  State<TrackingPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<TrackingPage> {
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
    return Scaffold(
      backgroundColor: whiteColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: greenColor,
            title: Text(
              widget.place.name,
              style: whiteTextStyle.copyWith(fontSize: 16.0),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                initialCameraPosition: CameraPosition(
                    target:
                        LatLng(widget.place.latitude, widget.place.longitude),
                    zoom: 12.0),
                markers: markers,
                polylines: Set<Polyline>.of(polylines.values),
                mapType: MapType.normal,
              ),
            ),
          )
        ],
      ),
    );
  }
}
