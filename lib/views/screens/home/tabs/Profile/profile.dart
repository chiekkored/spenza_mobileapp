import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:spenza/core/viewmodels/authViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/utilities/constants/icons.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/auth/sign_in/sigin.dart';
import 'package:spenza/views/screens/home/search/search.dart';
import 'package:spenza/views/screens/home/tabs/Profile/tabs/liked.dart';
import 'package:spenza/views/screens/home/tabs/Profile/tabs/recipes.dart';
import 'package:spenza/views/screens/home/tabs/home/tabs/cookNow.dart';
import 'package:spenza/views/screens/home/tabs/home/tabs/plan.dart';
import 'package:spenza/views/screens/home/tabs/recipe/recipe.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  int _selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    AuthViewModel _authVM = AuthViewModel();
    return SingleChildScrollView(
      // physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: CColors.White,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        _authVM.logout();
                        Navigator.of(context, rootNavigator: true)
                            .pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return SignInScreen();
                            },
                          ),
                          (_) => false,
                        );
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => SignInScreen()),
                        //   (Route<dynamic> route) => false,
                        // );
                      },
                      icon: Icon(
                        Icons.share,
                        color: CColors.MainText,
                      ),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 23.0),
                  child: Center(
                    child: CircleAvatar(
                      radius: 60.0,
                      foregroundImage:
                          NetworkImage("https://picsum.photos/200"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Center(
                      child: CustomTextBold(
                          text: "Ernst Blofeld",
                          size: 17.0,
                          color: CColors.PrimaryText)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextBold(
                              text: "32",
                              size: 17.0,
                              color: CColors.PrimaryText),
                          CustomTextMedium(
                              text: "Recipes",
                              size: 12.0,
                              color: CColors.SecondaryText)
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextBold(
                              text: "782",
                              size: 17.0,
                              color: CColors.PrimaryText),
                          CustomTextMedium(
                              text: "Following",
                              size: 12.0,
                              color: CColors.SecondaryText)
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextBold(
                              text: "1,287",
                              size: 17.0,
                              color: CColors.PrimaryText),
                          CustomTextMedium(
                              text: "Followers",
                              size: 12.0,
                              color: CColors.SecondaryText)
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          DefaultTabController(
            length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 50.0,
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
                          text: "Recipes",
                        ),
                        Tab(
                          text: "Liked",
                        )
                      ]),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Builder(builder: (context) {
                    switch (_selectedTab) {
                      case 0:
                        return RecipesTab();
                      case 1:
                        return LikedTab();
                    }
                    return Container();
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
