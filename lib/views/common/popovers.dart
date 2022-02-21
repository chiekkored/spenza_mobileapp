import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/auth/sign_in/sigin.dart';
import 'package:spenza/views/screens/home/scan/camera.dart';
import 'package:spenza/views/screens/home/upload/upload.dart';

import 'buttons.dart';

Future<dynamic> scanTabBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(32.0),
          topRight: const Radius.circular(32.0),
        ),
      ),
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(alignment: Alignment.centerLeft, child: CloseButton()),
                  CustomTextBold(
                      text: "Choose one option",
                      size: 17.0,
                      color: CColors.PrimaryText),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => pushNewScreen(context,
                            withNavBar: false, screen: UploadScreen()),
                        child: Container(
                          height: 186.0,
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 1.0, color: CColors.Outline),
                            color: CColors.White,
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/recipe.png",
                                height: 101.0,
                                width: 78.0,
                              ),
                              CustomTextBold(
                                  text: "Recipe",
                                  size: 15.0,
                                  color: CColors.PrimaryText),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => pushNewScreen(context,
                            withNavBar: false, screen: ScanCameraScreen()),
                        child: Container(
                          height: 186.0,
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 1.0, color: CColors.Outline),
                            color: CColors.White,
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/ingredients.png",
                                height: 101.0,
                                width: 78.0,
                              ),
                              CustomTextBold(
                                  text: "Ingredient",
                                  size: 15.0,
                                  color: CColors.PrimaryText),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}

class ModalBottomSheet extends StatefulWidget {
  const ModalBottomSheet({Key? key}) : super(key: key);

  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  double _ingredientsOnHandSlider = 0.0;
  double _cookingDurationSlider = 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CustomTextBold(
                text: "Add a Filter", size: 17.0, color: CColors.PrimaryText),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: CustomTextBold(
                text: "Tags", size: 17.0, color: CColors.PrimaryText),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 17.0),
                  child: CustomRadioButton(
                      text: "All",
                      color: CColors.PrimaryColor,
                      fontColor: CColors.White),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 17.0),
                  child: CustomRadioButton(
                      text: "Food",
                      color: CColors.Form,
                      fontColor: CColors.SecondaryText),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 17.0),
                  child: CustomRadioButton(
                      text: "Drink",
                      color: CColors.Form,
                      fontColor: CColors.SecondaryText),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: Row(
              children: [
                CustomTextBold(
                    text: "Ingredients On Hand ",
                    size: 17.0,
                    color: CColors.PrimaryText),
                CustomTextRegular(
                    text: "(in minutes)",
                    size: 17.0,
                    color: CColors.SecondaryText)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextBold(
                    text: "0%",
                    size: 15.0,
                    color: _ingredientsOnHandSlider >= 0
                        ? CColors.PrimaryColor
                        : CColors.SecondaryText),
                CustomTextBold(
                    text: "50%",
                    size: 15.0,
                    color: _ingredientsOnHandSlider >= 50
                        ? CColors.PrimaryColor
                        : CColors.SecondaryText),
                CustomTextBold(
                    text: "100%",
                    size: 15.0,
                    color: _ingredientsOnHandSlider >= 100
                        ? CColors.PrimaryColor
                        : CColors.SecondaryText),
              ],
            ),
          ),
          Slider(
            value: _ingredientsOnHandSlider,
            max: 100,
            inactiveColor: CColors.Outline,
            activeColor: CColors.PrimaryColor,
            onChanged: (double value) {
              setState(() {
                _ingredientsOnHandSlider = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: Row(
              children: [
                CustomTextBold(
                    text: "Cooking Duration ",
                    size: 17.0,
                    color: CColors.PrimaryText),
                CustomTextRegular(
                    text: "(in minutes)",
                    size: 17.0,
                    color: CColors.SecondaryText)
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
                    color: _cookingDurationSlider >= 0
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
            inactiveColor: CColors.Outline,
            activeColor: CColors.PrimaryColor,
            onChanged: (double value) {
              setState(() {
                _cookingDurationSlider = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 56.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomSecondaryButton(
                      text: "Cancel",
                      doOnPressed: () => Navigator.maybePop(context)),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: CustomPrimaryButton(
                      text: "Done",
                      doOnPressed: () => Navigator.maybePop(context)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
