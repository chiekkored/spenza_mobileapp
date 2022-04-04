import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/authViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/utilities/constants/icons.dart';
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
    var _userProvider = context.read<UserProvider>();
    return Material(
      type: MaterialType.transparency,
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: Container(
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
                                    child: Icon(
                                      CIcons.search,
                                      color: CColors.SecondaryText,
                                    )),
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
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: CustomRadioButton(
                                          doOnPressed: () async {},
                                          fontColor: CColors.White,
                                          text: "All",
                                          color: CColors.PrimaryColor),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: CustomRadioButton(
                                          doOnPressed: () {},
                                          fontColor: CColors.SecondaryText,
                                          text: "Food",
                                          color: CColors.Form),
                                    ),
                                    CustomRadioButton(
                                        doOnPressed: () {},
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
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 8.0,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                      color: CColors.White,
                      border:
                          Border(bottom: BorderSide(color: CColors.Outline))),
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
              ),
            ];
          },
          body: TabBarView(children: [
            CookNowTab(),
            PlanTab(),
          ]),
        ),
      ),
    );
  }
}
