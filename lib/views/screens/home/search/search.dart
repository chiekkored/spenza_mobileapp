import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/utilities/constants/icons.dart';
import 'package:spenza/views/common/popovers.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/tabs/home/home.dart';
import 'package:spenza/views/screens/home/upload/upload.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CColors.White,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: CColors.White,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 23.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Icon(
                              CIcons.back,
                              color: CColors.MainText,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                letterSpacing: 0.5,
                                color: CColors.MainText),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: CColors.Form,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 27.0, right: 11.0),
                                  child: Icon(
                                    CIcons.search,
                                    color: CColors.SecondaryText,
                                  ),
                                ),
                                hintText: "Search",
                                hintStyle: TextStyle(
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    letterSpacing: 0.5,
                                    color: CColors.SecondaryText),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(32.0),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: GestureDetector(
                            onTap: () => showCustomBottomSheet(context),
                            child: SvgPicture.asset(
                              "assets/svg/settings.svg",
                              height: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.0),
                  color: CColors.White,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svg/time.svg",
                                      // height: 24,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 17.0),
                                      child: CustomTextMedium(
                                          text: "Pancakes",
                                          size: 17,
                                          color: CColors.PrimaryText),
                                    )
                                  ],
                                ),
                                Icon(
                                  CIcons.arrow_upward,
                                  size: 14.0,
                                  color: CColors.SecondaryText,
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.0),
                  padding: EdgeInsets.all(24.0),
                  width: MediaQuery.of(context).size.width,
                  color: CColors.White,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextBold(
                          text: "Search suggestions",
                          size: 17.0,
                          color: CColors.PrimaryText),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Row(
                          children: [
                            CustomRadioButton(
                                text: "sushi",
                                color: CColors.Form,
                                fontColor: CColors.PrimaryText),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: CustomRadioButton(
                                  text: "breakfast",
                                  color: CColors.Form,
                                  fontColor: CColors.PrimaryText),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          children: [
                            CustomRadioButton(
                                text: "seafood",
                                color: CColors.Form,
                                fontColor: CColors.PrimaryText),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: CustomRadioButton(
                                  text: "fried rice",
                                  color: CColors.Form,
                                  fontColor: CColors.PrimaryText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
