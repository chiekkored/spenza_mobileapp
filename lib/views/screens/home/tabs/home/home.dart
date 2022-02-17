import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/search/search.dart';
import 'package:spenza/views/screens/home/tabs/home/tabs/cookNow.dart';
import 'package:spenza/views/screens/home/tabs/home/tabs/plan.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        // physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: CColors.White,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 23.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          pushNewScreen(context, screen: SearchScreen()),
                      child: Container(
                        height: 56.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: CColors.Form,
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 27.0, right: 11.0),
                              child: SvgPicture.asset("assets/svg/search.svg"),
                            ),
                            CustomTextMedium(
                                text: "Search",
                                size: 15,
                                color: CColors.SecondaryText)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextBold(
                              text: "Tags",
                              size: 17.0,
                              color: CColors.PrimaryText),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: CustomRadioButton(
                                      fontColor: CColors.White,
                                      text: "All",
                                      color: CColors.PrimaryColor),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: CustomRadioButton(
                                      fontColor: CColors.SecondaryText,
                                      text: "Food",
                                      color: CColors.Form),
                                ),
                                CustomRadioButton(
                                    fontColor: CColors.SecondaryText,
                                    text: "Drink",
                                    color: CColors.Form),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50.0,
                    color: CColors.White,
                    child: TabBar(
                        onTap: (value) => setState(() {
                              _selectedTab = value;
                            }),
                        indicatorColor: CColors.PrimaryColor,
                        labelColor: CColors.PrimaryText,
                        unselectedLabelColor: CColors.SecondaryText,
                        indicatorWeight: 3.0,
                        labelStyle: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          letterSpacing: 0.5,
                        ),
                        tabs: [
                          Tab(
                            text: "Cook now",
                          ),
                          Tab(
                            text: "Plan",
                          )
                        ]),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Builder(builder: (context) {
                      switch (_selectedTab) {
                        case 0:
                          return CookNowTab();
                        case 1:
                          return PlanTab();
                      }
                      return Container();
                    }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomRadioButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color fontColor;
  const CustomRadioButton({
    Key? key,
    required this.text,
    required this.color,
    required this.fontColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 19.0, horizontal: 12.0),
        child: Center(
          child: CustomTextBold(text: text, size: 15, color: fontColor),
        ),
      ),
    );
  }
}