import 'package:flutter/material.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/inputs.dart';
import 'package:spenza/views/common/texts.dart';

class UploadStep2Screen extends StatefulWidget {
  const UploadStep2Screen({Key? key}) : super(key: key);

  @override
  State<UploadStep2Screen> createState() => _UploadStep2ScreenState();
}

class _UploadStep2ScreenState extends State<UploadStep2Screen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CColors.White,
      child: SafeArea(
          child: Scaffold(
        body: SingleChildScrollView(
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
                        text: "2/2", size: 17.0, color: CColors.MainText)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 47.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextBold(
                          text: "Ingredients",
                          size: 17.0,
                          color: CColors.PrimaryText),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add),
                          CustomTextMedium(
                              text: "Group",
                              size: 15.0,
                              color: CColors.PrimaryText),
                        ],
                      ),
                    ],
                  ),
                ),
                ReorderableListView(children: [
                  TextField(
                    style: customTextFieldTextStyle(),
                    decoration:
                        customTextFieldInputDecoration(hint: "Enter food name"),
                  ),
                ], onReorder: (oldIndex, newIndex) {}),
                ReorderableListView.builder(
                    itemBuilder: itemBuilder,
                    itemCount: itemCount,
                    onReorder: onReorder)
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 70.0,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: CustomSecondaryButton(
                        text: "Back",
                        doOnPressed: () => Navigator.of(context).pop())),
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                    child:
                        CustomPrimaryButton(text: "Next", doOnPressed: () {})),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
