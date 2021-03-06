import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/postViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/recipeDetail/recipeDetail.dart';
import 'package:spenza/views/screens/home/userProfile/userProfile.dart';

class CustomGridViewWithoutDp extends StatelessWidget {
  const CustomGridViewWithoutDp({
    Key? key,
    required AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
    required String fromScreen,
  })  : snapshot = snapshot,
        fromScreen = fromScreen,
        super(key: key);

  final AsyncSnapshot<List<Map<String, dynamic>>> snapshot;
  // For hero widget tag combo
  final String fromScreen;

  @override
  Widget build(BuildContext context) {
    var _crossAxisSpacing = 25;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 300;
    var _aspectRatio = _width / cellHeight;

    var _userProvider = context.read<UserProvider>();
    PostViewModel _postVM = PostViewModel();

    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        shrinkWrap: true,
        itemCount: snapshot.data!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 25.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: _aspectRatio,
        ),
        itemBuilder: (BuildContext context, int index) {
          var _postData = snapshot.data![index];
          String postRecipeTitle = _postData["postRecipeTitle"];
          postRecipeTitle = postRecipeTitle
              .replaceFirst(
                  postRecipeTitle[0], postRecipeTitle[0].toUpperCase())
              .toString();
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: (() {
                            HapticFeedback.mediumImpact();
                            pushNewScreen(context,
                                screen: RecipeDetailScreen(
                                  imgUrl: _postData["postImageUrl"],
                                  postRecipeTitle: _postData["postRecipeTitle"],
                                  postPercent: _postData["postPercent"],
                                  postDuration: _postData["postDuration"],
                                  dpUrl: _userProvider.userInfo.dpUrl,
                                  name: _userProvider.userInfo.name,
                                  postDocId: _postData["id"],
                                  fromScreen: fromScreen,
                                  profileUid: _postData["authorUid"],
                                ),
                                withNavBar: false);
                          }),
                          child: Hero(
                            tag: _postData["id"] + fromScreen,
                            child: CachedNetworkImage(
                              imageUrl: _postData["postImageUrl"],
                              placeholder: (context, s) => Container(
                                color: CColors.Form,
                                height: MediaQuery.of(context).size.width / 2.4,
                              ),
                              imageBuilder: (context, image) {
                                return Image(
                                  image: image,
                                  fit: BoxFit.cover,
                                  height:
                                      MediaQuery.of(context).size.width / 2.4,
                                  width:
                                      MediaQuery.of(context).size.width / 2.4,
                                );
                              },
                              errorWidget: (context, str, dyn) {
                                return Center(child: Icon(Icons.error));
                              },
                            ),
                          ),
                        ),
                        Positioned(
                            top: 20.0,
                            right: 20.0,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: _postVM.getIfPostLiked(
                                    _userProvider.userInfo.uid,
                                    _postData["id"]),
                                builder: (context, streamSnapshot) {
                                  if (!streamSnapshot.hasData) {
                                    return GestureDetector(
                                      onTap: () async {
                                        HapticFeedback.selectionClick();
                                        bool result = await _postVM.likePost(
                                            _postData["authorUid"],
                                            streamSnapshot.data!.docs[index].id,
                                            _userProvider.userInfo.uid,
                                            _userProvider.userInfo.name,
                                            _userProvider.userInfo.dpUrl);
                                      },
                                      child: Container(
                                        height: 35.0,
                                        width: 35.0,
                                        decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(.2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/svg/heart.svg",
                                            height: 23.0,
                                            width: 23.0,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    if (streamSnapshot.data!.docs.length > 0) {
                                      return GestureDetector(
                                        onTap: () async {
                                          HapticFeedback.selectionClick();
                                          bool result =
                                              await _postVM.unlikePost(
                                            _userProvider.userInfo.uid,
                                            _postData["id"],
                                            _userProvider.userInfo.uid,
                                          );
                                        },
                                        child: Container(
                                          height: 35.0,
                                          width: 35.0,
                                          decoration: BoxDecoration(
                                              color: CColors.PrimaryColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/svg/heart.svg",
                                              height: 23.0,
                                              width: 23.0,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () async {
                                          HapticFeedback.selectionClick();
                                          bool result = await _postVM.likePost(
                                              _postData["authorUid"],
                                              _postData["id"],
                                              _userProvider.userInfo.uid,
                                              _userProvider.userInfo.name,
                                              _userProvider.userInfo.dpUrl);
                                        },
                                        child: Container(
                                          height: 35.0,
                                          width: 35.0,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(.2),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/svg/heart.svg",
                                              height: 23.0,
                                              width: 23.0,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                })),
                      ],
                    )),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CustomTextBold(
                      text: postRecipeTitle,
                      size: 17.0,
                      color: CColors.PrimaryText),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    CustomTextMedium(
                        text: _postData["postPercent"],
                        size: 12.0,
                        color: CColors.SecondaryText),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomTextMedium(
                          text: "???", size: 12.0, color: CColors.SecondaryText),
                    ),
                    CustomTextMedium(
                        text: _postData["postDuration"],
                        size: 12.0,
                        color: CColors.SecondaryText),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class CustomGridView extends StatelessWidget {
  const CustomGridView(
      {Key? key,
      required AsyncSnapshot<List<dynamic>> snapshot,
      required String fromScreen})
      : snapshot = snapshot,
        fromScreen = fromScreen,
        super(key: key);

  final AsyncSnapshot<List<dynamic>> snapshot;
  final String fromScreen;

  @override
  Widget build(BuildContext context) {
    var _crossAxisSpacing = 25;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 350;
    var _aspectRatio = _width / cellHeight;

    var _userProvider = context.read<UserProvider>();
    PostViewModel _postVM = PostViewModel();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(24),
        itemCount: snapshot.data!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 25.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: _aspectRatio,
        ),
        itemBuilder: (BuildContext context, int index) {
          var _authorData = snapshot.data![index][0];
          var _authorPostsData = snapshot.data![index][1];
          var _postDocId = snapshot.data![index][2];
          String postRecipeTitle = _authorPostsData["postRecipeTitle"];
          postRecipeTitle = postRecipeTitle
              .replaceFirst(
                  postRecipeTitle[0], postRecipeTitle[0].toUpperCase())
              .toString();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => pushNewScreen(context,
                    screen: UserProfileScreen(
                        uid: _authorData["uid"],
                        name: _authorData["name"],
                        dpUrl: _authorData["dpUrl"]),
                    withNavBar: false),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11.0),
                        child: CachedNetworkImage(
                          imageUrl: _authorData["dpUrl"],
                          placeholder: (context, s) => Container(
                            color: CColors.Form,
                            height: 31,
                            width: 31,
                          ),
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
                    Expanded(
                      child: CustomTextMedium(
                          text: _authorData["name"],
                          size: 12,
                          color: CColors.MainText),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (() {
                  HapticFeedback.mediumImpact();
                  pushNewScreen(context,
                      screen: RecipeDetailScreen(
                        imgUrl: _authorPostsData["postImageUrl"],
                        postRecipeTitle: _authorPostsData["postRecipeTitle"],
                        postPercent: _authorPostsData["postPercent"],
                        postDuration: _authorPostsData["postDuration"],
                        dpUrl: _authorData["dpUrl"],
                        name: _authorData["name"],
                        postDocId: _postDocId,
                        fromScreen: fromScreen,
                        profileUid: _authorData["uid"],
                      ),
                      withNavBar: false);
                }),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Stack(
                        children: [
                          Hero(
                            tag: _postDocId + fromScreen,
                            child: CachedNetworkImage(
                              imageUrl: _authorPostsData["postImageUrl"],
                              placeholder: (context, s) => Container(
                                color: CColors.Form,
                                height: MediaQuery.of(context).size.width / 2.4,
                              ),
                              imageBuilder: (context, image) {
                                return Image(
                                  image: image,
                                  fit: BoxFit.cover,
                                  height:
                                      MediaQuery.of(context).size.width / 2.4,
                                  width:
                                      MediaQuery.of(context).size.width / 2.4,
                                );
                              },
                              errorWidget: (context, str, dyn) {
                                return Center(child: Icon(Icons.error));
                              },
                            ),
                          ),
                          Positioned(
                            top: 20.0,
                            right: 20.0,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: _postVM.getIfPostLiked(
                                    _userProvider.userInfo.uid, _postDocId),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return GestureDetector(
                                      onTap: () async {
                                        HapticFeedback.selectionClick();
                                        bool result = await _postVM.likePost(
                                            _authorData["uid"],
                                            _postDocId,
                                            _userProvider.userInfo.uid,
                                            _userProvider.userInfo.name,
                                            _userProvider.userInfo.dpUrl);
                                      },
                                      child: Container(
                                        height: 35.0,
                                        width: 35.0,
                                        decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(.2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/svg/heart.svg",
                                            height: 23.0,
                                            width: 23.0,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    if (snapshot.data!.docs.length > 0) {
                                      return GestureDetector(
                                        onTap: () async {
                                          HapticFeedback.selectionClick();
                                          bool result =
                                              await _postVM.unlikePost(
                                            _authorData["uid"],
                                            _postDocId,
                                            _userProvider.userInfo.uid,
                                          );
                                        },
                                        child: Container(
                                          height: 35.0,
                                          width: 35.0,
                                          decoration: BoxDecoration(
                                              color: CColors.PrimaryColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/svg/heart.svg",
                                              height: 23.0,
                                              width: 23.0,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () async {
                                          HapticFeedback.selectionClick();
                                          bool result = await _postVM.likePost(
                                              _authorData["uid"],
                                              _postDocId,
                                              _userProvider.userInfo.uid,
                                              _userProvider.userInfo.name,
                                              _userProvider.userInfo.dpUrl);
                                        },
                                        child: Container(
                                          height: 35.0,
                                          width: 35.0,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(.2),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/svg/heart.svg",
                                              height: 23.0,
                                              width: 23.0,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                }),
                          ),
                        ],
                      )),
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CustomTextBold(
                      text: postRecipeTitle,
                      size: 17.0,
                      color: CColors.PrimaryText),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    CustomTextMedium(
                        text: _authorPostsData["postPercent"],
                        size: 12.0,
                        color: CColors.SecondaryText),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomTextMedium(
                          text: "???", size: 12.0, color: CColors.SecondaryText),
                    ),
                    CustomTextMedium(
                        text: _authorPostsData["postDuration"],
                        size: 12.0,
                        color: CColors.SecondaryText),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class CustomGridShimmer extends StatelessWidget {
  const CustomGridShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _crossAxisSpacing = 25;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 350;
    var _aspectRatio = _width / cellHeight;
    return Shimmer.fromColors(
      baseColor: CColors.Form,
      highlightColor: CColors.White,
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 25.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: _aspectRatio,
        ),
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11.0),
                      child: Container(
                        width: 31.0,
                        height: 31.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                  ),
                  Container(
                    width: 60.0,
                    height: 8.0,
                    color: Colors.white,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                      height: MediaQuery.of(context).size.width / 2.4,
                      // height: 100,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  width: 80.0,
                  height: 18.0,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 40.0,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomTextMedium(
                          text: "???", size: 12.0, color: CColors.SecondaryText),
                    ),
                    Container(
                      width: 40.0,
                      height: 8.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        itemCount: 2,
      ),
    );
  }
}

class CustomGridShimmerWithoutDp extends StatelessWidget {
  const CustomGridShimmerWithoutDp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _crossAxisSpacing = 25;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 276;
    var _aspectRatio = _width / cellHeight;
    return Shimmer.fromColors(
      baseColor: CColors.Form,
      highlightColor: CColors.White,
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 25.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: _aspectRatio,
        ),
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                      height: MediaQuery.of(context).size.width / 2.4,
                      // height: 100,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  width: 80.0,
                  height: 18.0,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 40.0,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomTextMedium(
                          text: "???", size: 12.0, color: CColors.SecondaryText),
                    ),
                    Container(
                      width: 40.0,
                      height: 8.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        itemCount: 2,
      ),
    );
  }
}
