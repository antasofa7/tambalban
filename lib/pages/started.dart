import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tambal_ban/theme.dart';

class StartedPage extends StatefulWidget {
  const StartedPage({Key? key}) : super(key: key);

  @override
  State<StartedPage> createState() => _StartedPageState();
}

class _StartedPageState extends State<StartedPage> {
  bool serviceEnabled = false;
  bool hasPermission = false;
  LocationPermission? permission;

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  checkGps() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission == await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are permanently denied');
        } else {
          hasPermission = true;
        }
      } else {
        hasPermission = true;
      }
    } else {
      await Geolocator.openLocationSettings();
      setState(() {
        checkGps();
      });
      print('GPS Service is not enabled, turn on GPS location.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(
              top: 120.0, right: 26.0, bottom: 60.0, left: 26.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [greenColor, greenColor.withOpacity(0)])),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aplikasi Tambal Ban Online',
                style: TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 50.0,
                    fontWeight: FontWeight.w600,
                    color: whiteColor),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: Container(
                  height: 50.0,
                  width: 250.0,
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        greenColor.withOpacity(0.5),
                        greenColor,
                      ]),
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                            color: greenColor.withOpacity(0.5),
                            offset: const Offset(0, 10),
                            blurRadius: 30.0)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cari Tambal Ban',
                        style: whiteTextStyle.copyWith(
                            fontSize: 18.0, fontWeight: semiBold),
                      ),
                      Icon(
                        Icons.arrow_right_alt,
                        color: whiteColor,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                'atau',
                style: whiteTextStyle,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/addPlace');
                },
                child: Text(
                  'Tambah tambal ban',
                  style: whiteTextStyle.copyWith(
                      fontSize: 16.0,
                      fontWeight: light,
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
