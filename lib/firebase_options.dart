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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDkWvVn2ZViBXQW8_qsc0R-7Rbr5y5ST9Y',
    appId: '1:840165651344:web:c52509904e34c126347915',
    messagingSenderId: '840165651344',
    projectId: 'fcuentas-3e40c',
    authDomain: 'fcuentas-3e40c.firebaseapp.com',
    storageBucket: 'fcuentas-3e40c.appspot.com',
    measurementId: 'G-BKG0F9MT9G',
    databaseURL: 'https://fcuentas-3e40c-default-rtdb.europe-west1.firebasedatabase.app'
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBpshkzZnp5RzW3GRQtNZaiPSS-340TGMw',
    appId: '1:840165651344:android:618cc017b3676498347915',
    messagingSenderId: '840165651344',
    projectId: 'fcuentas-3e40c',
    authDomain: 'fcuentas-3e40c.firebaseapp.com',
    storageBucket: 'fcuentas-3e40c.appspot.com',
    measurementId: 'G-BKG0F9MT9G',
    databaseURL: 'https://fcuentas-3e40c-default-rtdb.europe-west1.firebasedatabase.app'
  );
}
