import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/authViewModels.dart';
import 'package:spenza/core/viewmodels/profileViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/tabs/Profile/tabs/liked.dart';
import 'package:spenza/views/screens/home/tabs/Profile/tabs/recipes.dart';

class UserProfileScreen extends StatefulWidget {
  final String uid;
  final String name;
  final String dpUrl;
  const UserProfileScreen(
      {Key? key, required this.uid, required this.name, required this.dpUrl})
      : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with AutomaticKeepAliveClientMixin {
  ProfileViewModel _profileVM = ProfileViewModel();

  late Future<DocumentSnapshot<Object?>> _getUserData;
  late Stream<QuerySnapshot<Object?>> _getRecipes;
  late Stream<QuerySnapshot<Object?>> _getIsFollowing;
  late Stream<QuerySnapshot<Object?>> _getFollowing;
  late Stream<QuerySnapshot<Object?>> _getFollowers;

  @override
  void initState() {
    var _userProvider = context.read<UserProvider>();
    _getUserData = _profileVM.getUserData(widget.uid);
    _getRecipes = _profileVM.getRecipes(widget.uid);
    _getIsFollowing =
        _profileVM.getIsFollowing(_userProvider.userInfo.uid, widget.uid);
    _getFollowing = _profileVM.getFollowing(widget.uid);
    _getFollowers = _profileVM.getFollowers(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var _userProvider = context.read<UserProvider>();
    return Container(
      color: CColors.White,
      child: SafeArea(
        bottom: false,
        child: Material(
          color: CColors.Form,
          child: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverAppBar(
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
                  SliverToBoxAdapter(
                    child: Container(
                      color: CColors.White,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                                              imageUrl: widget.dpUrl,
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
                                                    placeholder: (_, s) {
                                                      return Container(
                                                        decoration:
                                                            new BoxDecoration(
                                                          color: CColors.Form,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      );
                                                    },
                                                    imageBuilder:
                                                        (context, image) {
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
                                            imageUrl: widget.dpUrl,
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
                                    }
                                  }),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Center(
                              child: FutureBuilder<DocumentSnapshot>(
                                  future: _getUserData,
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.done:
                                        if (snapshot.hasError) {
                                          print("-name- has Error");
                                          return CustomTextBold(
                                              text: widget.name,
                                              size: 17.0,
                                              color: CColors.PrimaryText);
                                        } else {
                                          print("-name- has Data");
                                          return CustomTextBold(
                                              text: snapshot.data!["name"],
                                              size: 17.0,
                                              color: CColors.PrimaryText);
                                        }
                                      default:
                                        print(
                                            "-name- maybe loading/no connection");
                                        return CustomTextBold(
                                            text: widget.name,
                                            size: 17.0,
                                            color: CColors.PrimaryText);
                                    }
                                  }),
                            ),
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
                                            print(
                                                "-Profile Recipe Count- has Error");
                                            return CustomTextBold(
                                                text: "0",
                                                size: 17.0,
                                                color: CColors.PrimaryText);
                                          } else {
                                            print(
                                                "-Profile Recipe Count- has Data");
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
                          ),
                          Visibility(
                              visible: _userProvider.userInfo.uid != widget.uid,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 24.0),
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: _getIsFollowing,
                                    builder: (context, snapshot) {
                                      // switch (snapshot.connectionState) {
                                      //   case ConnectionState.done:
                                      if (!snapshot.hasData) {
                                        print("-Is Following- has Error");
                                        return CustomPrimaryButton(
                                            text: "Follow", doOnPressed: () {});
                                      } else {
                                        if (snapshot.data!.docs.length > 0) {
                                          print("-Is Following- has Data");
                                          return CustomSecondaryButton(
                                              text: "Unfollow",
                                              doOnPressed: () async {
                                                await _profileVM
                                                    .setUnfollow(
                                                        _userProvider
                                                            .userInfo.uid,
                                                        widget.uid,
                                                        snapshot
                                                            .data!.docs[0].id)
                                                    .then((value) {
                                                  return null;
                                                });
                                              });
                                        } else {
                                          print(
                                              "-Is Following- has No Data: Not Following");
                                          return CustomPrimaryButton(
                                              text: "Follow",
                                              doOnPressed: () async {
                                                await _profileVM
                                                    .setFollow(
                                                      _userProvider
                                                          .userInfo.uid,
                                                      widget.uid,
                                                      widget.name,
                                                      widget.dpUrl,
                                                      _userProvider
                                                          .userInfo.name,
                                                      _userProvider
                                                          .userInfo.dpUrl,
                                                    )
                                                    .then((value) => null);
                                              });
                                        }
                                      }
                                      // default:
                                      //   return CustomPrimaryButton(
                                      //       text: "Follow", doOnPressed: () {});
                                      // }
                                    }),
                              ))
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
                          border: Border(
                              bottom: BorderSide(color: CColors.Outline))),
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
                RecipesTab(uid: widget.uid),
                LikedTab(uid: widget.uid),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
