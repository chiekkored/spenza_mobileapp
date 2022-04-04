import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/texts.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String imgUrl;
  final String postRecipeTitle;
  final String postPercent;
  final String postDuration;
  final String dpUrl;
  final String name;
  final String postDocId;
  final String fromScreen;

  const RecipeDetailScreen(
      {Key? key,
      required this.imgUrl,
      required this.postRecipeTitle,
      required this.postPercent,
      required this.postDuration,
      required this.dpUrl,
      required this.name,
      required this.postDocId,
      required this.fromScreen})
      : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  var ing = [
    "10 cacao beans (preferably peeled)",
    "10 raw cashews (or macadamia nuts)",
    "2 tablespoons raw honey"
  ];
  @override
  Widget build(BuildContext context) {
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
                      text: widget.postRecipeTitle,
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
                            text: "•",
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
                          CustomTextBold(
                              text: widget.name,
                              size: 15.0,
                              color: CColors.PrimaryText),
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
                          CustomTextBold(
                              text: "273 Likes",
                              size: 15.0,
                              color: CColors.PrimaryText)
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
                CustomTextBold(
                    text: "Description",
                    size: 17.0,
                    color: CColors.PrimaryText),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "We all love a good Chocolate Milk so why pollute ourselves with fake chocolate and high-glycemic sugar? This amazing nut-milk is delicious AND nutritious!",
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
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(
                    thickness: 1.0,
                  ),
                ),
                CustomTextBold(
                    text: "Ingredients",
                    size: 17.0,
                    color: CColors.PrimaryText),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0.0),
                      itemCount: 3,
                      itemBuilder: (context, index) {
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
                                  fillColor: MaterialStateProperty.all(
                                      CColors.AccentColor),
                                  value: true,
                                  shape: CircleBorder(),
                                  onChanged: (bool? value) {
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            CustomTextMedium(
                                text: ing[index],
                                size: 15.0,
                                color: CColors.MainText)
                          ],
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(
                    thickness: 1.0,
                  ),
                ),
                CustomTextBold(
                    text: "Steps", size: 17.0, color: CColors.PrimaryText),
                ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0.0),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: ((context, index) {
                      index++;
                      return Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Container(
                                  height: 25.0,
                                  width: 25.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: CColors.MainText),
                                  child: Center(
                                    child: CustomTextBold(
                                        text: index.toString(),
                                        size: 12.0,
                                        color: CColors.White),
                                  )),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextMedium(
                                      text: "Blend all ingredients",
                                      size: 15.0,
                                      color: CColors.MainText),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.imgUrl,
                                        height: 155,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }))
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
}
