import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/profileViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/grocery/grocery.dart';
import 'package:spenza/views/screens/home/pantry/pantry.dart';
import 'package:spenza/views/screens/home/tabs/Profile/tabs/liked.dart';
import 'package:spenza/views/screens/home/tabs/Profile/tabs/recipes.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  ProfileViewModel _profileVM = ProfileViewModel();

  late Future<DocumentSnapshot<Object?>> _getUserData;
  late Stream<QuerySnapshot<Object?>> _getRecipes;
  late Stream<QuerySnapshot<Object?>> _getFollowing;
  late Stream<QuerySnapshot<Object?>> _getFollowers;

  @override
  void initState() {
    var _userProvider = context.read<UserProvider>();
    _getUserData = _profileVM.getUserData(_userProvider.userInfo.uid);
    _getRecipes = _profileVM.getRecipes(_userProvider.userInfo.uid);
    _getFollowing = _profileVM.getFollowing(_userProvider.userInfo.uid);
    _getFollowers = _profileVM.getFollowers(_userProvider.userInfo.uid);
    super.initState();
  }

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
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              pushNewScreen(context, screen: PantryScreen());
                            },
                            icon: Icon(
                              Icons.food_bank,
                              size: 35.0,
                              color: CColors.MainText,
                            ),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          IconButton(
                            onPressed: () {
                              pushNewScreen(context, screen: GroceryScreen());
                            },
                            icon: Icon(
                              Icons.add_shopping_cart,
                              color: CColors.MainText,
                              size: 35.0,
                            ),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 23.0),
                        child: Center(
                          child: FutureBuilder<DocumentSnapshot>(
                              future: _getUserData,
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.done:
                                    if (snapshot.hasError) {
                                      debugPrint("🚫 -dpUrl- has Error");
                                      return SizedBox(
                                        height: 120.0,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              _userProvider.userInfo.dpUrl,
                                          imageBuilder: (context, image) {
                                            return CircleAvatar(
                                              radius: 60.0,
                                              backgroundColor:
                                                  Colors.transparent,
                                              foregroundImage: image,
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      debugPrint("🟢 -dpUrl- has Data");
                                      return SizedBox(
                                        height: 120.0,
                                        child: snapshot.data!["dpUrl"] !=
                                                "New User"
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    snapshot.data!["dpUrl"],
                                                imageBuilder: (context, image) {
                                                  return CircleAvatar(
                                                    radius: 60.0,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    foregroundImage: image,
                                                  );
                                                },
                                              )
                                            : CircleAvatar(
                                                radius: 80.0,
                                                backgroundColor:
                                                    Colors.transparent,
                                                foregroundImage: AssetImage(
                                                    "assets/images/logo.png"),
                                              ),
                                      );
                                    }
                                  default:
                                    debugPrint(
                                        "🚫 -dpUrl- maybe loading/no connection");
                                    return SizedBox(
                                      height: 120.0,
                                      child: CachedNetworkImage(
                                        imageUrl: _userProvider.userInfo.dpUrl,
                                        imageBuilder: (context, image) {
                                          return CircleAvatar(
                                            radius: 60.0,
                                            backgroundColor: Colors.transparent,
                                            foregroundImage: image,
                                          );
                                        },
                                      ),
                                    );
                                }
                              }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Center(
                            child: CustomTextBold(
                                text: _userProvider.userInfo.name,
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
                                StreamBuilder<QuerySnapshot>(
                                    stream: _getRecipes,
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        debugPrint(
                                            "🚫 -Profile Recipe Count- has Error");
                                        return CustomTextBold(
                                            text: "0",
                                            size: 17.0,
                                            color: CColors.PrimaryText);
                                      } else {
                                        debugPrint(
                                            "🟢 -Profile Recipe Count- has Data");
                                        return CustomTextBold(
                                            text: snapshot.data!.docs.length
                                                .toString(),
                                            size: 17.0,
                                            color: CColors.PrimaryText);
                                      }
                                    }),
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
                                StreamBuilder<QuerySnapshot>(
                                    stream: _getFollowing,
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        debugPrint(
                                            "🚫 -Profile Following Count- has Error");
                                        return CustomTextBold(
                                            text: "0",
                                            size: 17.0,
                                            color: CColors.PrimaryText);
                                      } else {
                                        debugPrint(
                                            "🟢 -Profile Following Count- has Data");
                                        return CustomTextBold(
                                            text: snapshot.data!.docs.length
                                                .toString(),
                                            size: 17.0,
                                            color: CColors.PrimaryText);
                                      }
                                    }),
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
                                StreamBuilder<QuerySnapshot>(
                                    stream: _getFollowers,
                                    builder: (context, snapshot) {
                                      // switch (snapshot.connectionState) {
                                      //   case ConnectionState.done:
                                      if (!snapshot.hasData) {
                                        debugPrint(
                                            "🚫 -Profile Followers Count- has Error");
                                        return CustomTextBold(
                                            text: "0",
                                            size: 17.0,
                                            color: CColors.PrimaryText);
                                      } else {
                                        debugPrint(
                                            "🟢 -Profile Followers Count- has Data");
                                        return CustomTextBold(
                                            text: snapshot.data!.docs.length
                                                .toString(),
                                            size: 17.0,
                                            color: CColors.PrimaryText);
                                      }
                                    }),
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
              ),
            ];
          },
          body: TabBarView(children: [
            RecipesTab(uid: _userProvider.userInfo.uid),
            LikedTab(uid: _userProvider.userInfo.uid),
          ]),
        ),
      ),
    );
  }
}
