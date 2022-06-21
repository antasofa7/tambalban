import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tambal_ban/theme.dart';

class TrackingPage extends StatefulWidget {
  final Map<dynamic, dynamic> place;
  const TrackingPage(
    this.place, {
    Key? key,
  }) : super(key: key);

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
        markerId: MarkerId(widget.place['items'].latitude.toString()),
        position: LatLng(
            widget.place['items'].latitude, widget.place['items'].longitude),
        infoWindow: InfoWindow(
          title: capitalize(widget.place['items'].name),
        ),
        icon: BitmapDescriptor.defaultMarker));
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
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: greenColor,
              title: Text(
                capitalize(widget.place['items'].name),
                style: whiteTextStyle.copyWith(fontSize: 16.0),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(widget.place['items'].latitude,
                          widget.place['items'].longitude),
                      zoom: 12.0),
                  markers: markers,
                  polylines: Set<Polyline>.of(polylines.values),
                  mapType: MapType.normal,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
