import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambal_ban/cubit/place_cubit.dart';
import 'package:tambal_ban/pages/add_place.dart';
import 'package:tambal_ban/pages/home.dart';
import 'package:tambal_ban/pages/search_page.dart';
import 'package:tambal_ban/pages/splash.dart';
import 'package:tambal_ban/pages/started.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PlaceCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashPage(),
          '/started': (context) => const StartedPage(),
          '/home': (context) => const HomePage(),
          '/addPlace': (context) => const AddPlace(),
          '/search': (context) => const SearchPage(),
        },
      ),
    );
  }
}
