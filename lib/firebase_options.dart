// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyC_JAKcUvIzBblG4TjL27Ip7D3bPj4QkNI',
    appId: '1:687612494339:web:e6adc7057cfacdffc98436',
    messagingSenderId: '687612494339',
    projectId: 'hotel-review-5727a',
    authDomain: 'hotel-review-5727a.firebaseapp.com',
    databaseURL: 'https://hotel-review-5727a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'hotel-review-5727a.firebasestorage.app',
    measurementId: 'G-PWPGDPXJ7D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBHKkXJzgWDf2QJWsoVRSmB6CyZELj-w4',
    appId: '1:687612494339:android:77a42ee6a6131e4fc98436',
    messagingSenderId: '687612494339',
    projectId: 'hotel-review-5727a',
    databaseURL: 'https://hotel-review-5727a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'hotel-review-5727a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAnAdea4Zt2P11m-bKTEos0C3jAsXmHuzk',
    appId: '1:687612494339:ios:a3df9788a596d621c98436',
    messagingSenderId: '687612494339',
    projectId: 'hotel-review-5727a',
    databaseURL: 'https://hotel-review-5727a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'hotel-review-5727a.firebasestorage.app',
    iosBundleId: 'com.example.reviewhotelpab',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAnAdea4Zt2P11m-bKTEos0C3jAsXmHuzk',
    appId: '1:687612494339:ios:a3df9788a596d621c98436',
    messagingSenderId: '687612494339',
    projectId: 'hotel-review-5727a',
    databaseURL: 'https://hotel-review-5727a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'hotel-review-5727a.firebasestorage.app',
    iosBundleId: 'com.example.reviewhotelpab',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC_JAKcUvIzBblG4TjL27Ip7D3bPj4QkNI',
    appId: '1:687612494339:web:c1590ddf5769d2e1c98436',
    messagingSenderId: '687612494339',
    projectId: 'hotel-review-5727a',
    authDomain: 'hotel-review-5727a.firebaseapp.com',
    databaseURL: 'https://hotel-review-5727a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'hotel-review-5727a.firebasestorage.app',
    measurementId: 'G-B3W0TD7J6J',
  );

}