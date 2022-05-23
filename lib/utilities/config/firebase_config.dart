import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class SpenzaFirebaseConfig {
  static FirebaseOptions? get platformOptions {
    if (kIsWeb) {
      // Web
      // return const FirebaseOptions(
      //   apiKey: 'AIzaSyB3xp0wxO-unpMOXUU0TZnpjX_6PHQqiAw',
      //   projectId: 'petbox-pocketdevs',
      //   messagingSenderId: '165593911046',
      //   appId: '1:165593911046:ios:cef31132297af312955887',
      // );
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
          appId: '1:1002872122808:ios:d16d47c80b6f9948ad334d',
          apiKey: 'AIzaSyCg-xLLjwqZFX23wtR7JcFhiDz5cD0c4m4',
          projectId: 'spenza-recipe-app',
          messagingSenderId: '1002872122808',
          storageBucket: "spenza-recipe-app.appspot.com");
    } else {
      // Android
      return const FirebaseOptions(
          appId: '1:1002872122808:android:603bf4f47cb90bd0ad334d',
          apiKey: 'AIzaSyCg-xLLjwqZFX23wtR7JcFhiDz5cD0c4m4',
          projectId: 'spenza-recipe-app',
          messagingSenderId: '1002872122808',
          storageBucket: "spenza-recipe-app.appspot.com");
    }
    return null;
  }
}
