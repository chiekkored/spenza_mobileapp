import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:group_button/group_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spenza/core/viewmodels/uploadViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/inputs.dart';
import 'package:spenza/views/common/popovers.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/upload/uploadStep2.dart';
import 'package:textfield_tags/textfield_tags.dart';

class UploadStep1Screen extends StatefulWidget {
  const UploadStep1Screen({Key? key}) : super(key: key);

  @override
  _UploadStep1ScreenState createState() => _UploadStep1ScreenState();
}

class _UploadStep1ScreenState extends State<UploadStep1Screen> {
  UploadViewModel _uploadVM = UploadViewModel();
  double _cookingDurationSlider = 10.0;
  TextEditingController _foodNameTextController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();
  TextfieldTagsController _tags = TextfieldTagsController();
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
                          try {
                            await _picker
                                .pickImage(source: ImageSource.gallery)
                                .then((value) {
                              if (value!.path != '') {
                                print(value);
                                setState(() {
                                  image = value;
                                  isCoverAttached = true;
                                });
                                showSuggested(context);
                              } else {
                                return null;
                              }
                              return null;
                            });
                          } catch (e) {
                            print("No photos selected");
                          }
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
                        textCapitalization: TextCapitalization.sentences,
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
                        textCapitalization: TextCapitalization.sentences,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: CustomTextBold(
                          text: "Tags", size: 17.0, color: CColors.PrimaryText),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextFieldTags(
                        textfieldTagsController: _tags,
                        initialTags: ["Food", "Drink"],
                        inputfieldBuilder:
                            (context, tec, fn, error, onChanged, onSubmitted) {
                          return ((context, sc, tags, onTagDelete) {
                            return TextField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: tec,
                              focusNode: fn,
                              style: customTextFieldTextStyle(),
                              decoration: InputDecoration(
                                // isDense: true,
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
                                hintText: _tags.hasTags ? '' : "Enter tags",
                                hintStyle: TextStyle(
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    letterSpacing: 0.5,
                                    color: CColors.SecondaryText),
                                errorText: error,
                                prefixIconConstraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.74),
                                prefixIcon: tags.isNotEmpty
                                    ? SingleChildScrollView(
                                        controller: sc,
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                            children: tags.map((String tag) {
                                          return Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                              color: Color.fromARGB(
                                                  255, 74, 137, 92),
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  child: Text(
                                                    '$tag',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onTap: () {
                                                    print("$tag selected");
                                                  },
                                                ),
                                                const SizedBox(width: 4.0),
                                                InkWell(
                                                  child: const Icon(
                                                    Icons.cancel,
                                                    size: 14.0,
                                                    color: Color.fromARGB(
                                                        255, 233, 233, 233),
                                                  ),
                                                  onTap: () {
                                                    onTagDelete(tag);
                                                  },
                                                )
                                              ],
                                            ),
                                          );
                                        }).toList()),
                                      )
                                    : null,
                              ),
                              onChanged: onChanged,
                              onSubmitted: onSubmitted,
                            );
                          });
                        },
                      ),
                    )
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
                    if (_foodNameTextController.text == '' ||
                        _descriptionTextController.text == '') {
                      return showCustomDialog(context, "Fields Required",
                          "Please fill all fields.", "OK", null);
                    } else {
                      final page = UploadStep2Screen(
                          coverPath: image.path,
                          foodName: _foodNameTextController.text,
                          description: _descriptionTextController.text,
                          cookingDuration: _cookingDurationSlider,
                          tags: _tags.getTags!);
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

  void showSuggested(BuildContext context) {
    String foodName = "";
    return showCustomModal(
        context,
        Container(
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            color: CColors.White,
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    CustomCloseButton(),
                    CustomTextBold(
                        text: "Suggested food name",
                        size: 18,
                        color: CColors.PrimaryText)
                  ],
                ),
              ),
              FutureBuilder<List<ImageLabel>>(
                  future: _uploadVM
                      .getSuggested(InputImage.fromFile(File(image.path))),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          print("-Get Suggested- has Error");
                          return CustomTextBold(
                              text: "Something went wrong.",
                              size: 15.0,
                              color: CColors.PrimaryText);
                        } else {
                          print("-Get Suggested- has Data");
                          return Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 24.0, horizontal: 8.0),
                                child: GroupButton(
                                  isRadio: true,
                                  buttons: snapshot.data!
                                      .map((e) => e.label)
                                      .toList(),
                                  onSelected: (str, index, isSelected) =>
                                      foodName = str.toString(),
                                  options: customGroupButtonOptions(),
                                ),
                              ),
                            ),
                          );
                        }
                      case ConnectionState.waiting:
                        print("-Get Suggested- waiting");
                        return Expanded(
                          child: Platform.isIOS
                              ? CupertinoActivityIndicator()
                              : CircularProgressIndicator(),
                        );
                      default:
                        return Expanded(
                          child: Platform.isIOS
                              ? CupertinoActivityIndicator()
                              : CircularProgressIndicator(),
                        );
                    }
                  }),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: CustomPrimaryButton(
                    text: "Confirm",
                    doOnPressed: () {
                      _foodNameTextController.text = foodName;
                      Navigator.maybePop(context);
                    }),
              )
            ],
          ),
        ));
  }
}
