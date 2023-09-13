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
    apiKey: 'AIzaSyD-3VOUvZAqaHYMNbOq0d1OdneZ5fgplyg',
    appId: '1:835569072407:android:f4a3bbb6b49753332f5f52',
    messagingSenderId: '835569072407',
    projectId: 'chatwe-21398',
    storageBucket: 'chatwe-21398.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAEUyze3jPW0sRtb654c5mLycehOBBnjpM',
    appId: '1:835569072407:ios:0c597187cd06966d2f5f52',
    messagingSenderId: '835569072407',
    projectId: 'chatwe-21398',
    storageBucket: 'chatwe-21398.appspot.com',
    androidClientId: '835569072407-h4ej08fbfc7ktmq7kng1tngdutlcv003.apps.googleusercontent.com',
    iosClientId: '835569072407-n1t3gaidsltuotunv27luschsjhsigpo.apps.googleusercontent.com',
    iosBundleId: 'com.example.wechat',
  );
}
