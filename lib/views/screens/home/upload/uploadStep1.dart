import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/inputs.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/upload/uploadStep2.dart';

class UploadStep1Screen extends StatefulWidget {
  const UploadStep1Screen({Key? key}) : super(key: key);

  @override
  _UploadStep1ScreenState createState() => _UploadStep1ScreenState();
}

class _UploadStep1ScreenState extends State<UploadStep1Screen> {
  double _cookingDurationSlider = 0.0;
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
                      child: DottedBorder(
                        color: CColors.Outline,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(16),
                        strokeWidth: 2,
                        dashPattern: [6, 6],
                        child: Container(
                          height: 161.0,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 22.0, bottom: 16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SvgPicture.asset("assets/svg/image.svg"),
                                Padding(
                                  padding: const EdgeInsets.only(top: 22.0),
                                  child: CustomTextBold(
                                      text: "Add Cover Photo",
                                      size: 15.0,
                                      color: CColors.PrimaryText),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: CustomTextMedium(
                                      text: "(up to 12 Mb)",
                                      size: 12.0,
                                      color: CColors.SecondaryText),
                                ),
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
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
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
                  doOnPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => UploadStep2Screen()));
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
