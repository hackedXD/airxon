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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCCqYolv6VVcbeQvllMKbdQYoXSAnkyiZY',
    appId: '1:901995539139:android:ca5fd0af8b304585739076',
    messagingSenderId: '901995539139',
    projectId: 'acknowldger-2022',
    databaseURL: 'https://acknowldger-2022-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'acknowldger-2022.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB7P7ksahDKDrQzJJlHKNiaG7-AeeHY6d4',
    appId: '1:901995539139:ios:82eee9835c2c25ec739076',
    messagingSenderId: '901995539139',
    projectId: 'acknowldger-2022',
    databaseURL: 'https://acknowldger-2022-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'acknowldger-2022.appspot.com',
    iosClientId: '901995539139-vq58s7rhdqir4fttosdhvgpus3ul546h.apps.googleusercontent.com',
    iosBundleId: 'com.example.ac',
  );
}
