import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambal_ban/cubit/connected_cubit.dart';
import 'package:tambal_ban/cubit/place_cubit.dart';
import 'package:tambal_ban/pages/add_place.dart';
import 'package:tambal_ban/pages/home.dart';
import 'package:tambal_ban/pages/location_permission.dart';
import 'package:tambal_ban/pages/search_page.dart';
import 'package:tambal_ban/pages/splash.dart';
import 'package:tambal_ban/pages/started.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  runApp(Builder(builder: (context) {
    return MyApp(
      connectivity: Connectivity(),
    );
  }));
}

class MyApp extends StatelessWidget {
  final Connectivity connectivity;
  const MyApp({Key? key, required this.connectivity}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PlaceCubit()),
        BlocProvider(create: (context) => ConnectedCubit(connectivity)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashPage(),
          '/location-permission': (context) => const LocationPermission(),
          '/started': (context) => const StartedPage(),
          '/home': (context) => const HomePage(),
          '/add-place': (context) => const AddPlace(),
          '/search': (context) => const SearchPage(),
        },
      ),
    );
  }
}
