import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tambal_ban/theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 3000), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/started',
        (route) => false,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/logo.png',
            width: 120.0,
            height: 120.0,
          ),
          const SizedBox(
            height: 24.0,
          ),
          Text('Tambal Ban \nOnline'.toUpperCase(),
              textAlign: TextAlign.center,
              style: blackTextStyle.copyWith(
                fontSize: 24.0,
                fontWeight: semiBold,
              ))
        ])),
      ),
    );
  }
}
