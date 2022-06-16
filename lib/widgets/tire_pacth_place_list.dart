import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tambal_ban/model/tire_patch_place.dart';
import 'package:tambal_ban/pages/detail.dart';
import 'package:tambal_ban/theme.dart';

class TirePatchPlaceList extends StatefulWidget {
  final TirePatchPlace place;
  final double latitude;
  final double longitude;
  const TirePatchPlaceList({
    Key? key,
    required this.place,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<TirePatchPlaceList> createState() => _TirePatchPlaceListState();
}

class _TirePatchPlaceListState extends State<TirePatchPlaceList> {
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
        margin: const EdgeInsets.only(bottom: 8.0),
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.asset(
                  widget.place.imageAsset,
                  height: 50.0,
                  width: 80.0,
                  fit: BoxFit.cover,
                )),
            const SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.place.name,
                        style: blackTextStyle.copyWith(
                          fontSize: 14.0,
                          fontWeight: semiBold,
                          overflow: TextOverflow.ellipsis,
                        )),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Text(widget.place.location,
                        style: grayTextStyle.copyWith(
                          fontSize: 10.0,
                        )),
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
                                  color: widget.place.isOpen
                                      ? greenColor
                                      : grayColor),
                              const SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                isOpen,
                                style: grayTextStyle.copyWith(
                                    fontSize: 10.0,
                                    color: widget.place.isOpen
                                        ? greenColor
                                        : grayColor),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.near_me_outlined,
                                  size: 14.0, color: grayColor),
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
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
