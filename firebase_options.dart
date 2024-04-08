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
        return macos;
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
    apiKey: 'AIzaSyAEwjJZsrsOElQh9icAIxK3AD4Pwlk8py8',
    appId: '1:982219671680:web:3f8293503dfd5a0301fe65',
    messagingSenderId: '982219671680',
    projectId: 'crud-28e5f',
    authDomain: 'crud-28e5f.firebaseapp.com',
    databaseURL: 'https://crud-28e5f-default-rtdb.firebaseio.com',
    storageBucket: 'crud-28e5f.appspot.com',
    measurementId: 'G-TB3F2HGDCT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfqqexUA49aNV3fQPmaWSMwzv3mxZz35s',
    appId: '1:982219671680:android:8519dd87bf78f13c01fe65',
    messagingSenderId: '982219671680',
    projectId: 'crud-28e5f',
    databaseURL: 'https://crud-28e5f-default-rtdb.firebaseio.com',
    storageBucket: 'crud-28e5f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBSLxSUXXU0qVX3Ar8YFIrC7O5T9XFqE7c',
    appId: '1:982219671680:ios:95bb22699a89707801fe65',
    messagingSenderId: '982219671680',
    projectId: 'crud-28e5f',
    databaseURL: 'https://crud-28e5f-default-rtdb.firebaseio.com',
    storageBucket: 'crud-28e5f.appspot.com',
    iosBundleId: 'com.example.cw06',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBSLxSUXXU0qVX3Ar8YFIrC7O5T9XFqE7c',
    appId: '1:982219671680:ios:489f0cc3e31482c201fe65',
    messagingSenderId: '982219671680',
    projectId: 'crud-28e5f',
    databaseURL: 'https://crud-28e5f-default-rtdb.firebaseio.com',
    storageBucket: 'crud-28e5f.appspot.com',
    iosBundleId: 'com.example.cw06.RunnerTests',
  );
}
