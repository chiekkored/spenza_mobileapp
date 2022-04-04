import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/authViewModels.dart';
import 'package:spenza/core/viewmodels/profileViewModels.dart';
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
  ProfileViewModel _profileVM = ProfileViewModel();

  late Future<DocumentSnapshot<Object?>> _getUserData;
  late Future<QuerySnapshot<Object?>> _getRecipes;
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
    AuthViewModel _authVM = AuthViewModel();
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
                          child: FutureBuilder<DocumentSnapshot>(
                              future: _getUserData,
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.done:
                                    if (snapshot.hasError) {
                                      print("-dpUrl- has Error");
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
                                      print("-dpUrl- has Data");
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
                                    print(
                                        "-dpUrl- maybe loading/no connection");
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
                                FutureBuilder<QuerySnapshot>(
                                    future: _getRecipes,
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.done:
                                          if (snapshot.hasError) {
                                            print(
                                                "-Profile Recipes Count- has Error");
                                            return Text(
                                              '${snapshot.error}',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            );
                                          } else {
                                            print(
                                                "-Profile Recipes Count- has Data");
                                            return CustomTextBold(
                                                text: snapshot.data!.docs.length
                                                    .toString(),
                                                size: 17.0,
                                                color: CColors.PrimaryText);
                                          }
                                        default:
                                          return CustomTextBold(
                                              text: "0",
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
                                      // switch (snapshot.connectionState) {
                                      //   case ConnectionState.done:
                                      if (!snapshot.hasData) {
                                        print(
                                            "-Profile Following Count- has Error");
                                        return CustomTextBold(
                                            text: "0",
                                            size: 17.0,
                                            color: CColors.PrimaryText);
                                      } else {
                                        print(
                                            "-Profile Following Count- has Data");
                                        return CustomTextBold(
                                            text: snapshot.data!.docs.length
                                                .toString(),
                                            size: 17.0,
                                            color: CColors.PrimaryText);
                                      }
                                      //   default:
                                      //     return CustomTextBold(
                                      //         text: "0",
                                      //         size: 17.0,
                                      //         color: CColors.PrimaryText);
                                      // }
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
                                        print(
                                            "-Profile Followers Count- has Error");
                                        return CustomTextBold(
                                            text: "0",
                                            size: 17.0,
                                            color: CColors.PrimaryText);
                                      } else {
                                        print(
                                            "-Profile Followers Count- has Data");
                                        return CustomTextBold(
                                            text: snapshot.data!.docs.length
                                                .toString(),
                                            size: 17.0,
                                            color: CColors.PrimaryText);
                                      }
                                      //   default:
                                      //     return CustomTextBold(
                                      //         text: "0",
                                      //         size: 17.0,
                                      //         color: CColors.PrimaryText);
                                      // }
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
            LikedTab(),
          ]),
        ),
      ),
    );
  }
}
