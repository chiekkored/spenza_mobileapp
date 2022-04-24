import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

class UploadStep2Screen extends StatefulWidget {
  final String coverPath;
  final String foodName;
  final String description;
  final double cookingDuration;
  const UploadStep2Screen(
      {Key? key,
      required this.coverPath,
      required this.foodName,
      required this.description,
      required this.cookingDuration})
      : super(key: key);

  @override
  State<UploadStep2Screen> createState() => _UploadStep2ScreenState();
}

class _UploadStep2ScreenState extends State<UploadStep2Screen> {
  final _formKey = GlobalKey<FormState>();

  UploadViewModel _uploadVM = UploadViewModel();

  List<Widget> _inputIngredients = [];
  List<Widget> _inputSteps = [];

  List<TextEditingController> _ingredientTextControllerList = [];
  List<TextEditingController> _stepsTextControllerList = [];
  List<XFile?> _imagesList = [];

  int _countIngredients = 0;
  int _countSteps = 0;
  int _labelSteps = 1;

  @override
  void initState() {
    super.initState();
    _addInputIngredients();
    _addInputSteps();
  }

  void _addInputIngredients() {
    TextEditingController controller = TextEditingController();
    _ingredientTextControllerList.add(controller);
    _inputIngredients = List.from(_inputIngredients)
      ..add(ListTile(
        dense: true,
        contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
        key: Key("$_countIngredients"),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 15.0),
              child: SvgPicture.asset("assets/svg/drag_icon.svg"),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: TextField(
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                style: customTextFieldTextStyle(),
                decoration:
                    customTextFieldInputDecoration(hint: "Enter ingredient"),
              ),
            ),
          ],
        ),
      ));
    setState(() => ++_countIngredients);
  }

  void _addInputSteps() {
    TextEditingController controller = TextEditingController();
    _stepsTextControllerList.add(controller);
    ImagePicker picker = ImagePicker();
    _inputSteps = List.from(_inputSteps)
      ..add(ListTile(
        dense: true,
        contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
        key: Key("$_countSteps"),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Container(
                      height: 25.0,
                      width: 25.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: CColors.MainText),
                      child: Center(
                        child: CustomTextBold(
                            text: _labelSteps.toString(),
                            size: 12.0,
                            color: CColors.White),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 18.0),
                  child: Container(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: SvgPicture.asset("assets/svg/drag_icon.svg"),
                  ),
                ),
              ],
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                children: [
                  TextField(
                      controller: controller,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 4,
                      style: customTextFieldTextStyle(),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Tell a little about your food",
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
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: OutlinedButton(
                      onPressed: () async {
                        print(_imagesList.iterator.current);
                        if (_imagesList.asMap().containsKey(_countSteps - 1)) {
                          return null;
                        } else {
                          var photo = await picker.pickImage(
                              source: ImageSource.camera);
                          if (photo == null) {
                            return null;
                          }
                          _imagesList.insert(_countSteps - 1, photo);
                          setState(() {});
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: CColors.Form,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 19.0),
                        child: Center(
                          child: SvgPicture.asset("assets/svg/camera.svg"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
    setState(() {
      _countSteps++;
      _labelSteps++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CColors.White,
      child: SafeArea(
          child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: CColors.White,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              int count = 0;
                              Navigator.of(context)
                                  .popUntil((_) => count++ >= 2);
                            },
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
                      Padding(
                        padding: const EdgeInsets.only(top: 26.0),
                        child: ReorderableListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: _inputIngredients,
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }
                                final items =
                                    _inputIngredients.removeAt(oldIndex);
                                _inputIngredients.insert(newIndex, items);
                              });
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: CustomTransparentButton(
                            text: "+ Ingredient",
                            doOnPressed: () => _addInputIngredients()),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  color: CColors.White,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextBold(
                            text: "Steps",
                            size: 17.0,
                            color: CColors.PrimaryText),
                        Padding(
                          padding: const EdgeInsets.only(top: 26.0),
                          child: ReorderableListView(
                              buildDefaultDragHandles:
                                  false, // Set to true if draggable
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: _inputSteps,
                              onReorder: (oldIndex, newIndex) {
                                setState(() {
                                  if (newIndex > oldIndex) {
                                    newIndex -= 1;
                                  }
                                  final items = _inputSteps.removeAt(oldIndex);
                                  _inputSteps.insert(newIndex, items);
                                });
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 32.0),
                          child: CustomTransparentButton(
                              text: "+ Steps",
                              doOnPressed: () {
                                if (_stepsTextControllerList[_countSteps - 1]
                                            .text !=
                                        '' &&
                                    _imagesList
                                        .asMap()
                                        .containsKey(_countSteps - 1)) {
                                  _addInputSteps();
                                } else {
                                  return showCustomDialog(
                                      context,
                                      "Fields Required",
                                      "Please fill in Step $_countSteps first.",
                                      "OK",
                                      null);
                                }
                              }),
                        ),
                        _imagesList.isNotEmpty
                            ? Container(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _imagesList.length,
                                  itemBuilder: ((context, index) {
                                    if (_imagesList.isNotEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16.0, right: 8.0),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              child: Image.file(
                                                File(_imagesList[index]!.path),
                                                fit: BoxFit.cover,
                                                width: 100,
                                              ),
                                            ),
                                            Container(
                                                height: 25.0,
                                                width: 25.0,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: CColors.MainText),
                                                child: Center(
                                                  child: CustomTextBold(
                                                      text: "${index + 1}",
                                                      size: 12.0,
                                                      color: CColors.White),
                                                )),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
                  child: CustomPrimaryButton(
                    text: "Next",
                    doOnPressed: () async {
                      UserModel _user = context.read<UserProvider>().userInfo;

                      // for (var item in _ingredientTextControllerList) {
                      //   if (item.text == '') {
                      //     print("all ingredient needs to be filled out");
                      //     Navigator.maybePop(context);
                      //     return null;
                      //   }
                      // }
                      for (var item in _stepsTextControllerList) {
                        if (item.text == '') {
                          return showCustomDialog(context, "Field Required",
                              "Steps needs to be filled out", "OK", null);
                        }
                      }
                      if (_imagesList.length < _countSteps) {
                        return showCustomDialog(context, "Field Required",
                            "Steps' images needs to be filled out", "OK", null);
                      }
                      showCustomModal(
                          context,
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 48.0),
                            decoration: BoxDecoration(
                              color: CColors.White,
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            child: Platform.isIOS
                                ? CupertinoActivityIndicator()
                                : CircularProgressIndicator(),
                          ));
                      await _uploadVM
                          .uploadRecipe(
                              _user.uid,
                              widget.coverPath,
                              widget.foodName,
                              widget.description,
                              widget.cookingDuration,
                              _ingredientTextControllerList,
                              _stepsTextControllerList,
                              _imagesList)
                          .then((value) {
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
                                        padding:
                                            const EdgeInsets.only(top: 32.0),
                                        child: CustomTextBold(
                                            text: "Upload Success",
                                            size: 22.0,
                                            color: CColors.MainText),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "Your recipe has been uploaded, you can see it on your profile",
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
                                        padding:
                                            const EdgeInsets.only(top: 24.0),
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
                                    child: Text("Error Uploading")));
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
