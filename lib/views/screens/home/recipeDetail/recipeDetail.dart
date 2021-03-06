import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/recipeDetailViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/list.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/userProfile/userProfile.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String imgUrl;
  final String postRecipeTitle;
  final String postPercent;
  final String postDuration;
  final String dpUrl;
  final String name;
  final String postDocId;
  final String fromScreen;
  final String profileUid;

  const RecipeDetailScreen(
      {Key? key,
      required this.imgUrl,
      required this.postRecipeTitle,
      required this.postPercent,
      required this.postDuration,
      required this.dpUrl,
      required this.name,
      required this.postDocId,
      required this.fromScreen,
      required this.profileUid})
      : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<QuerySnapshot> _getLikes;
  late Future<DocumentSnapshot> _getRecipeDetails;
  bool _isGroceryAdded = false;
  RecipeDetailsViewModel _recipeDetailVM = RecipeDetailsViewModel();
  int _isAllIngredientsCount = 0;

  @override
  void initState() {
    _getLikes = _recipeDetailVM.getLikes(widget.postDocId, widget.profileUid);
    _getRecipeDetails =
        _recipeDetailVM.getRecipeDetails(widget.postDocId, widget.profileUid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _userProvider = context.read<UserProvider>();
    return Scaffold(
      body: SlidingUpPanel(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
        parallaxEnabled: true,
        minHeight: MediaQuery.of(context).size.height / 2,
        maxHeight: MediaQuery.of(context).size.height,
        panelBuilder: (ScrollController sc) => SingleChildScrollView(
          controller: sc,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 5.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                        color: CColors.Outline,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomTextBold(
                      text: widget.postRecipeTitle.replaceFirst(
                          widget.postRecipeTitle[0],
                          widget.postRecipeTitle[0].toUpperCase()),
                      size: 17.0,
                      color: CColors.PrimaryText),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomTextMedium(
                          text: "Food",
                          size: 15.0,
                          color: CColors.SecondaryText),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomTextMedium(
                            text: "???",
                            size: 15.0,
                            color: CColors.SecondaryText),
                      ),
                      CustomTextMedium(
                          text: widget.postDuration,
                          size: 15.0,
                          color: CColors.SecondaryText),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18.0),
                              child: CachedNetworkImage(
                                imageUrl: widget.dpUrl,
                                imageBuilder: (context, image) {
                                  return Image(
                                    image: image,
                                    fit: BoxFit.cover,
                                    height: 31,
                                    width: 31,
                                  );
                                },
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => pushNewScreen(context,
                                screen: UserProfileScreen(
                                    uid: widget.profileUid,
                                    name: widget.name,
                                    dpUrl: widget.dpUrl)),
                            child: CustomTextBold(
                                text: widget.name,
                                size: 15.0,
                                color: CColors.PrimaryText),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: CColors.PrimaryColor),
                              height: 32.0,
                              width: 32.0,
                              child: Center(
                                child: SvgPicture.asset(
                                    "assets/svg/heart_fill.svg"),
                              ),
                            ),
                          ),
                          FutureBuilder<QuerySnapshot>(
                              future: _getLikes,
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.done:
                                    if (snapshot.hasError) {
                                      debugPrint(
                                          "????-Recipe Detail Count- has Error");
                                      return CustomTextBold(
                                          text: "0 Likes",
                                          size: 15.0,
                                          color: CColors.PrimaryText);
                                    } else {
                                      debugPrint(
                                          "????-Recipe Detail Count- has Data");
                                      return CustomTextBold(
                                          text:
                                              "${snapshot.data!.docs.length.toString()} ${snapshot.data!.docs.length > 1 ? "likes" : "like"}",
                                          size: 15.0,
                                          color: CColors.PrimaryText);
                                    }
                                  case ConnectionState.waiting:
                                    debugPrint(
                                        "???-Recipe Detail Count- waiting");
                                    return Text("waiting");
                                  default:
                                    return CustomTextBold(
                                        text: "0 Likes",
                                        size: 15.0,
                                        color: CColors.PrimaryText);
                                }
                              })
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(
                    thickness: 1.0,
                  ),
                ),
                FutureBuilder<DocumentSnapshot>(
                    future: _getRecipeDetails,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          var postData = snapshot.data!;
                          List postDataIngredients = postData["ingredients"];
                          List postDataSteps = postData["steps"];
                          if (snapshot.hasError) {
                            debugPrint("???? -Recipe Detail- has Error");
                            return CustomTextBold(
                                text: "Encountered an Error.",
                                size: 17.0,
                                color: CColors.PrimaryText);
                          } else {
                            debugPrint("???? -Recipe Detail- has Data");
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextBold(
                                    text: "Description",
                                    size: 17.0,
                                    color: CColors.PrimaryText),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    postData["postDescription"],
                                    style: TextStyle(
                                        height: 1.6,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0,
                                        letterSpacing: 0.5,
                                        color: CColors.SecondaryText),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Divider(
                                    thickness: 1.0,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomTextBold(
                                        text: "Ingredients",
                                        size: 17.0,
                                        color: CColors.PrimaryText),
                                    StatefulBuilder(
                                      builder: (BuildContext context,
                                          void Function(void Function())
                                              setState) {
                                        return TextButton(
                                          onPressed: () async {
                                            if (_isAllIngredientsCount ==
                                                postDataIngredients.length) {
                                              setState(() {
                                                _isGroceryAdded = true;
                                              });
                                              bool _isGroceryAddedResponse =
                                                  await _recipeDetailVM
                                                      .addToGrocery(
                                                          _userProvider
                                                              .userInfo.uid,
                                                          postDataIngredients);
                                              if (_isGroceryAddedResponse) {
                                                const snackBar = SnackBar(
                                                  content:
                                                      Text('Grocery Added'),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);

                                                setState(() {});
                                              } else {
                                                setState(() {
                                                  _isGroceryAdded = false;
                                                });
                                              }
                                            } else {
                                              SnackBar snackBar = SnackBar(
                                                backgroundColor:
                                                    Colors.yellow[700],
                                                content: Text(
                                                    'Pantry already existed'),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          },
                                          child: Container(
                                            height: 35.0,
                                            width: 50.0,
                                            decoration: BoxDecoration(
                                                color: _isGroceryAdded
                                                    ? CColors.Form
                                                    : CColors.PrimaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(8.0)),
                                            child: Icon(
                                              _isGroceryAdded
                                                  ? Icons.check
                                                  : Icons.add_shopping_cart,
                                              color: CColors.White,
                                            ),
                                          ),
                                          style: ButtonStyle(
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.all(0.0),
                                      itemCount: postDataIngredients.length,
                                      itemBuilder: (context, index) {
                                        if (postDataIngredients[index] == '') {
                                          return CustomTextMedium(
                                              text: "No Ingredients",
                                              size: 15.0,
                                              color: CColors.SecondaryText);
                                        } else {
                                          return ingredientsSection(
                                              _userProvider,
                                              postDataIngredients,
                                              index);
                                        }
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Divider(
                                    thickness: 1.0,
                                  ),
                                ),
                                CustomTextBold(
                                    text: "Steps",
                                    size: 17.0,
                                    color: CColors.PrimaryText),
                                ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(0.0),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: postDataSteps.length,
                                    itemBuilder: ((context, index) {
                                      int stepIndex = index + 1;
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 18.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12.0),
                                              child: Container(
                                                  height: 25.0,
                                                  width: 25.0,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: CColors.MainText),
                                                  child: Center(
                                                    child: CustomTextBold(
                                                        text: stepIndex
                                                            .toString(),
                                                        size: 12.0,
                                                        color: CColors.White),
                                                  )),
                                            ),
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CustomTextMedium(
                                                        text:
                                                            postDataSteps[index]
                                                                ["stepsText"],
                                                        size: 15.0,
                                                        color:
                                                            CColors.MainText),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              postDataSteps[
                                                                      index][
                                                                  "stepsImage"],
                                                          placeholder: (context,
                                                                  s) =>
                                                              Container(
                                                                  color: CColors
                                                                      .Form,
                                                                  height: 155,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width),
                                                          imageBuilder:
                                                              (context, image) {
                                                            return Image(
                                                              image: image,
                                                              height: 155,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              fit: BoxFit.cover,
                                                            );
                                                          },
                                                          errorWidget: (context,
                                                              str, dyn) {
                                                            return Container();
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }))
                              ],
                            );
                          }
                        case ConnectionState.waiting:
                          debugPrint("??? -Recipe Detail- waiting");
                          return CustomRecipeDetailListShimmer();
                        default:
                          debugPrint("???? -Recipe Detail- no connection");
                          return CustomTextBold(
                              text: "Please check internet connection.",
                              size: 17.0,
                              color: CColors.SecondaryText);
                      }
                    })
              ],
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: widget.postDocId + widget.fromScreen,
                  child: CachedNetworkImage(
                    imageUrl: widget.imgUrl,
                    height: (MediaQuery.of(context).size.height / 2) + 30,
                    width: (MediaQuery.of(context).size.height / 2) + 30,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10.0,
                  left: 15.0,
                  child: SafeArea(
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(.2),
                      ),
                      child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: const Icon(Icons.chevron_left),
                        color: CColors.White,
                        iconSize: 30.0,
                        onPressed: () => Navigator.maybePop(context),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<QuerySnapshot<Object?>> ingredientsSection(
      UserProvider _userProvider,
      List<dynamic> postDataIngredients,
      int index) {
    return FutureBuilder<QuerySnapshot>(
        future: _recipeDetailVM.getIfPantryExist(_userProvider.userInfo.uid,
            postDataIngredients[index]["ingredientText"]),
        builder: (context, isExist) {
          if (isExist.hasData) {
            if (isExist.data!.docs.isNotEmpty) {
              var pantryData = isExist.data!.docs.first;
              int pantryQty = int.parse(pantryData["pantryQuantity"]);
              int ingredientQty =
                  int.parse(postDataIngredients[index]["ingredientQty"]);
              if (pantryQty >= ingredientQty) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          splashRadius: 0.0,
                          checkColor: CColors.PrimaryColor,
                          fillColor:
                              MaterialStateProperty.all(CColors.AccentColor),
                          value: true,
                          shape: CircleBorder(),
                          onChanged: (bool? value) {
                            return null;
                          },
                        ),
                      ),
                    ),
                    CustomTextMedium(
                        text:
                            "${postDataIngredients[index]["ingredientQty"]} ${postDataIngredients[index]["ingredientUnit"]} ${postDataIngredients[index]["ingredientText"]}",
                        size: 15.0,
                        color: CColors.MainText)
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Tooltip(
                      message:
                          "You need ${(ingredientQty - pantryQty).toString()} more ${pantryData["pantryUnit"]}",
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13.0, vertical: 12.0),
                        child: Container(
                          height: 22.0,
                          width: 22.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow[700]),
                          child: Icon(
                            Icons.question_mark,
                            color: CColors.White,
                            size: 16.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CustomTextMedium(
                          text:
                              "${postDataIngredients[index]["ingredientQty"]} ${postDataIngredients[index]["ingredientUnit"]} ${postDataIngredients[index]["ingredientText"]}",
                          size: 15.0,
                          color: CColors.MainText),
                    )
                  ],
                );
              }
            } else {
              // Counter if all ingredients are in the pantry. Add grocery checker
              _isAllIngredientsCount++;
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        splashRadius: 0.0,
                        checkColor: CColors.PrimaryColor,
                        fillColor:
                            MaterialStateProperty.all(CColors.PrimaryColor),
                        value: false,
                        shape: CircleBorder(),
                        onChanged: (bool? value) {
                          return null;
                        },
                      ),
                    ),
                  ),
                  CustomTextMedium(
                      text:
                          "${postDataIngredients[index]["ingredientQty"]} ${postDataIngredients[index]["ingredientUnit"]} ${postDataIngredients[index]["ingredientText"]}",
                      size: 15.0,
                      color: CColors.MainText)
                ],
              );
            }
          } else {
            return CustomTextMedium(
                text: "Checking pantry", size: 12.0, color: CColors.Form);
          }
        });
  }
}
