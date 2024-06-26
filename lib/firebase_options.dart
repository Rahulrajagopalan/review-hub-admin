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
    apiKey: 'AIzaSyBNwpqHVeKSXx-mwiaYly9JpBC1dFiGkZk',
    appId: '1:847644249396:web:068e9a00b5e82bd91de961',
    messagingSenderId: '847644249396',
    projectId: 'review-hub-master-5962d',
    authDomain: 'review-hub-master-5962d.firebaseapp.com',
    storageBucket: 'review-hub-master-5962d.appspot.com',
    measurementId: 'G-26VSQG71MZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB0XpGnXvCWZpMHlAABAZ3dK9IDlKdBkQc',
    appId: '1:847644249396:android:bd75ff632fa2c23d1de961',
    messagingSenderId: '847644249396',
    projectId: 'review-hub-master-5962d',
    storageBucket: 'review-hub-master-5962d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyChFlRqTmxGMKG_JNYjRJSgpMAX9HTWJDI',
    appId: '1:847644249396:ios:f6a460c2c1606fd81de961',
    messagingSenderId: '847644249396',
    projectId: 'review-hub-master-5962d',
    storageBucket: 'review-hub-master-5962d.appspot.com',
    iosBundleId: 'com.example.reviewHubAdmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyChFlRqTmxGMKG_JNYjRJSgpMAX9HTWJDI',
    appId: '1:847644249396:ios:f6a460c2c1606fd81de961',
    messagingSenderId: '847644249396',
    projectId: 'review-hub-master-5962d',
    storageBucket: 'review-hub-master-5962d.appspot.com',
    iosBundleId: 'com.example.reviewHubAdmin',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBNwpqHVeKSXx-mwiaYly9JpBC1dFiGkZk',
    appId: '1:847644249396:web:b208410513c146451de961',
    messagingSenderId: '847644249396',
    projectId: 'review-hub-master-5962d',
    authDomain: 'review-hub-master-5962d.firebaseapp.com',
    storageBucket: 'review-hub-master-5962d.appspot.com',
    measurementId: 'G-LXH1KLRNN7',
  );
}
