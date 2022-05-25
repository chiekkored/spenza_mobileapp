import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:spenza/main.dart';

class ScanCameraScreen extends StatefulWidget {
  const ScanCameraScreen({Key? key}) : super(key: key);

  @override
  _ScanCameraScreenState createState() => _ScanCameraScreenState();
}

class _ScanCameraScreenState extends State<ScanCameraScreen> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return CircularProgressIndicator();
    }
    return Scaffold(
      body: Stack(
        // alignment: FractionalOffset.center,
        children: [
          Positioned.fill(
            child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: CameraPreview(controller)),
          ),
          // Positioned.fill(
          //   child: Opacity(
          //     opacity: 0.3,
          //     child: new Image.network(
          //       'https://picsum.photos/3000/4000',
          //       fit: BoxFit.fill,
          //     ),
          //   ),
          // ),
          Positioned(
            top: 60.0,
            left: 24.0,
            child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF).withOpacity(0.3),
                    shape: BoxShape.circle),
                child: CloseButton()),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
