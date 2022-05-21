import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/filterProvider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/authViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/auth/sign_in/sigin.dart';
import 'package:spenza/views/screens/home/pantryPost/pantryPost.dart';
import 'package:spenza/views/screens/home/scan/camera.dart';
import 'package:spenza/views/screens/home/upload/uploadStep1.dart';

import 'buttons.dart';

/// "Choose one option" Bottom Sheet
Future<dynamic> scanTabBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
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
                  Align(
                      alignment: Alignment.centerLeft,
                      child: CustomCloseButton()),
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
                        onTap: () async {
                          final page = UploadStep1Screen();
                          pushNewScreen(context,
                              withNavBar: false, screen: page);
                        },
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
                        // onTap: () => pushNewScreen(context,
                        //     withNavBar: false, screen: ScanCameraScreen()),
                        onTap: () => pushNewScreen(context,
                            withNavBar: false, screen: PantryPostScreen()),
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
                                  text: "Pantry",
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

/// "Choose one option" Bottom Sheet
Future<dynamic> profileBottomSheet(BuildContext context) {
  AuthViewModel _authVM = AuthViewModel();
  return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
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
              GestureDetector(
                onTap: () {
                  _authVM.logout();
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return SignInScreen();
                      },
                    ),
                    (_) => false,
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(
                      width: 16.0,
                    ),
                    CustomTextRegular(
                        text: "Logout", size: 16.0, color: CColors.MainText)
                  ],
                ),
              )
            ],
          ),
        );
      });
}

typedef ParentFunctionCallback = void Function(String value);

/// Settings filter Bottom Sheet
class ModalBottomSheet extends StatefulWidget {
  final ParentFunctionCallback setSearchFilter;
  const ModalBottomSheet({Key? key, required this.setSearchFilter})
      : super(key: key);

  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  double _ingredientsOnHandSlider = 0.0;
  double _cookingDurationSlider = 0.0;
  GroupButtonController _tagSelectedController =
      GroupButtonController(selectedIndex: 0);
  String _selectedTag = "";
  int _selectedTagIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    var searchProvider = context.read<FilterProvider>();
    _ingredientsOnHandSlider = searchProvider.ingredientOnHand;
    _cookingDurationSlider = searchProvider.cookingDuration;
    _tagSelectedController.selectIndex(searchProvider.tagIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var filterProvider = context.read<FilterProvider>();
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
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: GroupButton(
                    controller: _tagSelectedController,
                    isRadio: true,
                    onSelected: (str, index, isSelected) {
                      _selectedTag = str.toString();
                      _selectedTagIndex = index;
                    },
                    options: customGroupButtonOptions(),
                    buttons: ["All", "Food", "Drink"],
                  ),
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
                      doOnPressed: () {
                        print("_selectedTag $_selectedTag");
                        filterProvider.filterSet(
                            _selectedTag == "All" ? "" : _selectedTag,
                            _selectedTagIndex,
                            _ingredientsOnHandSlider,
                            _cookingDurationSlider);
                        widget.setSearchFilter("Search Filter");
                        Navigator.maybePop(context);
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// Alert Dialog
///
/// @param context Screen context to pass
/// @param title Alert dialog title
/// @param content Alert dialog content body
/// @param buttonText Text inside the button
/// @param page Navigator push to page
void showCustomDialog(BuildContext context, String title, String content,
    String buttonText, dynamic page) {
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(
              content,
              style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                  letterSpacing: 0.5,
                  color: CColors.MainText),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(buttonText),
                onPressed: () {
                  if (page != null) {
                    // ignore: unnecessary_statements
                    page;
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  } else {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(
              content,
              style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                  letterSpacing: 0.5,
                  color: CColors.MainText),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(buttonText),
                onPressed: () {
                  if (page != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => page),
                    );
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

/// Modal Dialog
///
/// @param context Screen context to pass
/// @param widget Alert dialog content body
void showCustomModal(BuildContext context, Widget widget) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: widget,
        );
      });
}

/// Contact Support Alert Dialog
///
/// @param context Screen context to pass
void showErrorDialog(BuildContext context) {
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Error"),
            content: Text(
              "Something went wrong. Contact our support",
              style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                  letterSpacing: 0.5,
                  color: CColors.MainText),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Okay"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  } else {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(
              "Something went wrong. Contact our support",
              style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                  letterSpacing: 0.5,
                  color: CColors.MainText),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Okay"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }
}

/// Snackbar popover
SnackBar showCustomSnackbar(String content) {
  return SnackBar(content: Text(content));
}
