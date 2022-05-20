import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/filterProvider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/authViewModels.dart';
import 'package:spenza/utilities/config/firebase_config.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/screens/auth/sign_in/sigin.dart';
import 'package:spenza/views/screens/auth/verification/verificationEmail.dart';
import 'package:spenza/views/screens/home/navigation.dart';
import 'package:spenza/views/screens/splash.dart';

import 'views/screens/onboarding/onboarding.dart';

/// TODO: If firestore change, change dpUrl default link

// List Available Cameras
List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase Initialization
  await Firebase.initializeApp(
    options: SpenzaFirebaseConfig.platformOptions,
  );
  try {
    // Camera Initialization
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserProvider>.value(
        value: UserProvider(),
      ),
      ChangeNotifierProvider<FilterProvider>.value(
        value: FilterProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userProvider = context.read<UserProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primarySwatch: Colors.green, splashColor: CColors.MainText),
      home: Container(
        color: CColors.White,
        child: SafeArea(
            child: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.userChanges(),
                builder: (context, user) {
                  if (user.hasData) {
                    print(user.data!.emailVerified);
                    if (user.data!.emailVerified) {
                      return FutureBuilder<bool>(
                          future: userProvider.getUserPreference(),
                          builder: (context, snapshot) {
                            if (snapshot.data == true) {
                              return const Navigation();
                            }
                            return const Navigation();
                          });
                    } else {
                      return const VerificationEmailScreen();
                    }
                  } else {
                    return const OnboardingScreen();
                  }
                })),
      ),
    );
  }
}
