import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:group_button/group_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/models/userModel.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/uploadViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/inputs.dart';
import 'package:spenza/views/common/popovers.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/upload/uploadStep2.dart';

class PantryPostScreen extends StatefulWidget {
  const PantryPostScreen({Key? key}) : super(key: key);

  @override
  State<PantryPostScreen> createState() => _PantryPostScreenState();
}

class _PantryPostScreenState extends State<PantryPostScreen> {
  UploadViewModel _uploadVM = UploadViewModel();
  TextEditingController _foodNameTextController = TextEditingController();
  TextEditingController _quantityTextController = TextEditingController();
  TextEditingController _unitTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile image = XFile("");
  bool isCoverAttached = false;

  @override
  void initState() {
    super.initState();
    _quantityTextController.text = "0";
  }

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
                            debugPrint("No photos selected");
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
                        controller: _foodNameTextController,
                        style: customTextFieldTextStyle(),
                        decoration: customTextFieldInputDecoration(
                            hint: "Enter food name"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: CustomTextBold(
                          text: "Quantity",
                          size: 17.0,
                          color: CColors.PrimaryText),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setState) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () => setState(() {
                                        int quantity = int.parse(
                                            _quantityTextController.text);
                                        if (quantity > 0) {
                                          quantity--;
                                          _quantityTextController.text =
                                              quantity.toString();
                                        }
                                      }),
                                  icon: Icon(Icons.remove)),
                              Expanded(
                                child: TextField(
                                  controller: _quantityTextController,
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  style: customTextFieldTextStyle(),
                                  decoration: customTextFieldInputDecoration(
                                      hint: "Enter food quantity"),
                                ),
                              ),
                              IconButton(
                                  onPressed: () => setState(() {
                                        int quantity = int.parse(
                                            _quantityTextController.text);
                                        quantity++;
                                        _quantityTextController.text =
                                            quantity.toString();
                                      }),
                                  icon: Icon(Icons.add)),
                            ],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: CustomTextBold(
                          text: "Unit", size: 17.0, color: CColors.PrimaryText),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextField(
                        controller: _unitTextController,
                        style: customTextFieldTextStyle(),
                        decoration: customTextFieldInputDecoration(
                            hint: "Enter quantity unit"),
                      ),
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
                  text: "Add to pantry",
                  doOnPressed: () async {
                    if (!isCoverAttached ||
                        _foodNameTextController.text == '' ||
                        _quantityTextController.text == '' ||
                        _unitTextController.text == '') {
                      return showCustomDialog(context, "Fields Required",
                          "Please fill all fields.", "OK", null);
                    } else {
                      UserModel _user = context.read<UserProvider>().userInfo;
                      showCustomModal(
                          context,
                          Container(
                            padding: EdgeInsets.all(48.0),
                            decoration: BoxDecoration(
                              color: CColors.White,
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            child: Platform.isIOS
                                ? CupertinoActivityIndicator()
                                : CircularProgressIndicator(),
                          ));
                      bool value = await _uploadVM.uploadPantry(
                          _user.uid,
                          image.path,
                          _foodNameTextController.text,
                          _quantityTextController.text,
                          _unitTextController.text);
                      Navigator.of(context).maybePop(context);
                      value
                          ? showCustomModal(
                              context,
                              Container(
                                padding: EdgeInsets.all(48.0),
                                decoration: BoxDecoration(
                                  color: CColors.White,
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0),
                                      child: Image.asset(
                                          "assets/images/upload-success.png"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 32.0),
                                      child: CustomTextBold(
                                          text: "Successfully added",
                                          size: 22.0,
                                          color: CColors.MainText),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "Your pantry has been added, you can see it on the Pantry Page",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.0,
                                            letterSpacing: 0.5,
                                            color: CColors.MainText),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 24.0),
                                      child: CustomPrimaryButton(
                                          text: "Back to Home",
                                          doOnPressed: () =>
                                              Navigator.of(context).popUntil(
                                                  (route) => route.isFirst)),
                                    )
                                  ],
                                ),
                              ))
                          : showCustomModal(
                              context,
                              Container(
                                  padding: EdgeInsets.all(48.0),
                                  decoration: BoxDecoration(
                                    color: CColors.White,
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  child: Text("Error Adding")));
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
                          debugPrint("🚫 -Get Suggested- has Error");
                          return CustomTextBold(
                              text: "Something went wrong.",
                              size: 15.0,
                              color: CColors.PrimaryText);
                        } else {
                          debugPrint("🟢 -Get Suggested- has Data");
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
                        debugPrint("⏳ -Get Suggested- waiting");
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
