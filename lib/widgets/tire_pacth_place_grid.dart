import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tambal_ban/model/tire_patch_place.dart';
import 'package:tambal_ban/pages/detail.dart';
import 'package:tambal_ban/theme.dart';

class TirePatchPlaceGrid extends StatefulWidget {
  final TirePatchPlace place;
  final double latitude;
  final double longitude;
  const TirePatchPlaceGrid(
      {Key? key,
      required this.place,
      required this.latitude,
      required this.longitude})
      : super(key: key);

  @override
  State<TirePatchPlaceGrid> createState() => _TirePatchPlaceGridState();
}

class _TirePatchPlaceGridState extends State<TirePatchPlaceGrid> {
  double distanceInMeters = 0.0;
  @override
  void initState() {
    getDistance();
    super.initState();
  }

  void getDistance() {
    distanceInMeters = Geolocator.distanceBetween(widget.latitude,
        widget.longitude, widget.place.latitude, widget.place.longitude);
  }

  @override
  Widget build(BuildContext context) {
    String isOpen = widget.place.isOpen ? 'Buka' : 'Tutup';
    double distance = distanceInMeters / 1000;
    String distanceInString = distance.toStringAsFixed(2);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                place: widget.place,
                distance: distanceInString,
                latitude: widget.latitude,
                longitude: widget.longitude,
              ),
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.asset(
              widget.place.imageAsset,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            widget.place.name,
            style:
                blackTextStyle.copyWith(fontSize: 12.0, fontWeight: semiBold),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
            widget.place.location,
            style: grayTextStyle.copyWith(fontSize: 10.0),
          ),
          const SizedBox(
            height: 6.0,
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.watch_later_outlined,
                        size: 14.0,
                        color: widget.place.isOpen ? greenColor : grayColor),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      isOpen,
                      style: grayTextStyle.copyWith(
                          fontSize: 10.0,
                          color: widget.place.isOpen ? greenColor : grayColor),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.near_me_outlined, size: 14.0, color: grayColor),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Text('$distanceInString km',
                        style: grayTextStyle.copyWith(
                          fontSize: 10.0,
                        ))
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
