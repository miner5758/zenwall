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
    apiKey: 'AIzaSyD89SOgcCUUqhSVFbGrDS9GXj5V0t42XP8',
    appId: '1:864653692219:web:8776d6045ff9e98b60fb1e',
    messagingSenderId: '864653692219',
    projectId: 'superb-metric-348117',
    authDomain: 'superb-metric-348117.firebaseapp.com',
    databaseURL: 'https://superb-metric-348117-default-rtdb.firebaseio.com',
    storageBucket: 'superb-metric-348117.appspot.com',
    measurementId: 'G-M6QFYJ8NF3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfCfxLc14bxAjVzpL98Sxml3ILtaAbvvo',
    appId: '1:864653692219:android:3fd91310dd70566160fb1e',
    messagingSenderId: '864653692219',
    projectId: 'superb-metric-348117',
    databaseURL: 'https://superb-metric-348117-default-rtdb.firebaseio.com',
    storageBucket: 'superb-metric-348117.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZ-sTeBxeHJpVE2IqEWbqQIZAPJy-rXY8',
    appId: '1:864653692219:ios:a253b4ba0a7e0f1d60fb1e',
    messagingSenderId: '864653692219',
    projectId: 'superb-metric-348117',
    databaseURL: 'https://superb-metric-348117-default-rtdb.firebaseio.com',
    storageBucket: 'superb-metric-348117.appspot.com',
    iosClientId: '864653692219-7654mj5312boi8doppmahtt87ngjaccb.apps.googleusercontent.com',
    iosBundleId: 'com.example.zenwall',
  );
}
