// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAhpkppDoN2geNDX5sLKBD3SwRnC7a4p2s',
    appId: '1:742528959230:web:85920c293d0816fcd79baf',
    messagingSenderId: '742528959230',
    projectId: 'tambal-ban-3081c',
    authDomain: 'tambal-ban-3081c.firebaseapp.com',
    storageBucket: 'tambal-ban-3081c.appspot.com',
    measurementId: 'G-D18VNEHHLT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_9eHgiSbxgbQQd_hL_e_pLGIO4uEGzcM',
    appId: '1:742528959230:android:6e7bcd6699c2f55dd79baf',
    messagingSenderId: '742528959230',
    projectId: 'tambal-ban-3081c',
    storageBucket: 'tambal-ban-3081c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXItn1qYCN_6eb1vbwLv24dvW-RVArXf0',
    appId: '1:742528959230:ios:2e48ffae09c3f63ad79baf',
    messagingSenderId: '742528959230',
    projectId: 'tambal-ban-3081c',
    storageBucket: 'tambal-ban-3081c.appspot.com',
    iosClientId: '742528959230-u79uqnnt999cf9ndmev2lroded004vof.apps.googleusercontent.com',
    iosBundleId: 'com.example.tambalBan',
  );
}
