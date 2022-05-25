import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/filterProvider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/utilities/config/firebase_options.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/screens/auth/verification/verificationEmail.dart';
import 'package:spenza/views/screens/home/navigation.dart';

import 'views/screens/onboarding/onboarding.dart';

// List Available Cameras
List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase Initialization
  await Firebase.initializeApp(
    name: "spenza-recipe-app",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    // Camera Initialization
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('Error in fetching the cameras: $e');
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
