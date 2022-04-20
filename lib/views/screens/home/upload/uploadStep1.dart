import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/inputs.dart';
import 'package:spenza/views/common/popovers.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/upload/uploadStep2.dart';

class UploadStep1Screen extends StatefulWidget {
  const UploadStep1Screen({Key? key}) : super(key: key);

  @override
  _UploadStep1ScreenState createState() => _UploadStep1ScreenState();
}

class _UploadStep1ScreenState extends State<UploadStep1Screen> {
  double _cookingDurationSlider = 10.0;
  TextEditingController _foodNameTextController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile image = XFile("");
  bool isCoverAttached = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CColors.White,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              color: CColors.White,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: CustomTextBold(
                              text: "Cancel",
                              size: 17.0,
                              color: CColors.SecondaryColor),
                        ),
                        CustomTextSemiBold(
                            text: "1/2", size: 17.0, color: CColors.MainText)
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: GestureDetector(
                        onTap: () async {
                          await _picker
                              .pickImage(source: ImageSource.gallery)
                              .then((value) {
                            if (value!.path != '') {
                              setState(() {
                                image = value;
                                isCoverAttached = true;
                              });
                            } else {
                              return null;
                            }
                            return null;
                          });
                        },
                        child: DottedBorder(
                          color: CColors.Outline,
                          borderType: BorderType.RRect,
                          radius: Radius.circular(16),
                          strokeWidth: 2,
                          dashPattern: [6, 6],
                          child: Container(
                            height: 161.0,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                if (isCoverAttached) ...[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.file(
                                      File(image.path),
                                      fit: BoxFit.cover,
                                      height: 161.0,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  )
                                ] else ...[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 22.0, bottom: 16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SvgPicture.asset(
                                            "assets/svg/image.svg"),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 22.0),
                                          child: CustomTextBold(
                                              text: "Add Cover Photo",
                                              size: 15.0,
                                              color: CColors.PrimaryText),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: CustomTextMedium(
                                              text: "(up to 12 Mb)",
                                              size: 12.0,
                                              color: CColors.SecondaryText),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: CustomTextBold(
                          text: "Food Name",
                          size: 17.0,
                          color: CColors.PrimaryText),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextField(
                        controller: _foodNameTextController,
                        style: customTextFieldTextStyle(),
                        decoration: customTextFieldInputDecoration(
                            hint: "Enter food name"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: CustomTextBold(
                          text: "Description",
                          size: 17.0,
                          color: CColors.PrimaryText),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextField(
                        controller: _descriptionTextController,
                        maxLines: 3,
                        keyboardType: TextInputType.text,
                        style: customTextFieldTextStyle(),
                        decoration: InputDecoration(
                          hintText: "Tell me about your food",
                          hintStyle: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              letterSpacing: 0.5,
                              color: CColors.SecondaryText),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: CColors.Outline,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: CColors.PrimaryColor,
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomTextBold(
                              text: "Cooking Duration ",
                              size: 17.0,
                              color: CColors.PrimaryText),
                          CustomTextBold(
                              text: "(in minutes)",
                              size: 17.0,
                              color: CColors.SecondaryText),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextBold(
                              text: "<10",
                              size: 15.0,
                              color: _cookingDurationSlider >= 10
                                  ? CColors.PrimaryColor
                                  : CColors.SecondaryText),
                          CustomTextBold(
                              text: "30",
                              size: 15.0,
                              color: _cookingDurationSlider >= 30
                                  ? CColors.PrimaryColor
                                  : CColors.SecondaryText),
                          CustomTextBold(
                              text: ">60",
                              size: 15.0,
                              color: _cookingDurationSlider >= 60
                                  ? CColors.PrimaryColor
                                  : CColors.SecondaryText),
                        ],
                      ),
                    ),
                    Slider(
                      value: _cookingDurationSlider,
                      max: 60,
                      min: 10,
                      inactiveColor: CColors.Outline,
                      activeColor: CColors.PrimaryColor,
                      onChanged: (double value) {
                        setState(() {
                          _cookingDurationSlider = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 70.0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: CustomPrimaryButton(
                  text: "Next",
                  doOnPressed: () async {
                    // Google_ml_kit
                    final inputImage = InputImage.fromFile(File(image.path));
                    FirebaseCustomModel objectLabelerModel =
                        await FirebaseModelDownloader.instance.getModel(
                            'Object-Labeler',
                            FirebaseModelDownloadType
                                .localModelUpdateInBackground);
                    FirebaseCustomModel foodModel =
                        await FirebaseModelDownloader.instance.getModel(
                            'Food',
                            FirebaseModelDownloadType
                                .localModelUpdateInBackground);

                    final imagePDModel = GoogleMlKit.vision.imageLabeler();
                    final imageLabelerOLModel = GoogleMlKit.vision.imageLabeler(
                        CustomImageLabelerOptions(
                            customModel: CustomLocalModel.file,
                            customModelPath: objectLabelerModel.file.path));
                    final imageLabelerFModel = GoogleMlKit.vision.imageLabeler(
                        CustomImageLabelerOptions(
                            customModel: CustomLocalModel.file,
                            customModelPath: foodModel.file.path));

                    final List<ImageLabel> mlKitLabels =
                        await imagePDModel.processImage(inputImage);
                    final List<ImageLabel> objectLabels =
                        await imageLabelerOLModel.processImage(inputImage);
                    final List<ImageLabel> foodLabels =
                        await imageLabelerFModel.processImage(inputImage);
                    print("MLKit Pre-defined Model:");
                    for (ImageLabel label in mlKitLabels) {
                      print("Label: ${label.label}");
                      // print("Index: ${label.index}");
                      print("Confidence: ${label.confidence}");
                    }
                    print("");
                    print("--------------");
                    print("");
                    print("Object Labeler Model:");
                    for (ImageLabel label in objectLabels) {
                      print("Label: ${label.label}");
                      // print("Index: ${label.index}");
                      print("Confidence: ${label.confidence}");
                    }
                    print("");
                    print("--------------");
                    print("");
                    print("Food Model:");
                    for (ImageLabel label in foodLabels) {
                      print("Label: ${label.label}");
                      // print("Index: ${label.index}");
                      print("Confidence: ${label.confidence}");
                    }

                    if (!isCoverAttached ||
                        _foodNameTextController.text == '' ||
                        _descriptionTextController.text == '') {
                      return showCustomDialog(context, "Fields Required",
                          "Please fill all fields.", "OK", null);
                    } else {
                      final page = UploadStep2Screen(
                          coverPath: image.path,
                          foodName: _foodNameTextController.text,
                          description: _descriptionTextController.text,
                          cookingDuration: _cookingDurationSlider);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => page));
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
