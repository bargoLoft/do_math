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
    apiKey: 'AIzaSyDn2UCEblHRxeqOjZdBywLRhiGb-xYhPgY',
    appId: '1:506054873697:web:dd37adf3ffdf4059f41020',
    messagingSenderId: '506054873697',
    projectId: 'domath-5f2ca',
    authDomain: 'domath-5f2ca.firebaseapp.com',
    storageBucket: 'domath-5f2ca.appspot.com',
    measurementId: 'G-GKGJEH1TQT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBs6WFMTqduKjyuH1K3j1WC9qxU_4dxjII',
    appId: '1:506054873697:android:95bf6ddbe354b0f6f41020',
    messagingSenderId: '506054873697',
    projectId: 'domath-5f2ca',
    storageBucket: 'domath-5f2ca.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAbTaUR0IpVMlJK9RxrfwpQOKEPQ6RVoEY',
    appId: '1:506054873697:ios:b4137e283da6241af41020',
    messagingSenderId: '506054873697',
    projectId: 'domath-5f2ca',
    storageBucket: 'domath-5f2ca.appspot.com',
    iosClientId: '506054873697-7kjjb1loenivkifuh21c90lrrjv7hfqu.apps.googleusercontent.com',
    iosBundleId: 'com.bargoLoft.domath',
  );
}
