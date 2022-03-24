import 'package:flutter/material.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/tabs/Profile/tabs/liked.dart';
import 'package:spenza/views/screens/home/tabs/Profile/tabs/recipes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int _selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CColors.White,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: CColors.MainText),
            backgroundColor: CColors.White,
            elevation: 0.0,
            primary: false,
            leading: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: CustomBackButton(),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.share,
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
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
                        padding: const EdgeInsets.only(top: 24.0),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 24.0),
                        child: CustomPrimaryButton(
                            text: "Follow", doOnPressed: () {}),
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
                            border: Border(
                                bottom: BorderSide(color: CColors.Outline))),
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
          ),
        ),
      ),
    );
  }
}
