import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/cookNowViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/popovers.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/userProfile/userProfile.dart';

class CookNowTab extends StatefulWidget {
  const CookNowTab({Key? key}) : super(key: key);

  @override
  _CookNowTabState createState() => _CookNowTabState();
}

class _CookNowTabState extends State<CookNowTab> {
  @override
  Widget build(BuildContext context) {
    CookNowViewModel _cookNowVM = CookNowViewModel();
    var _userProvider = context.read<UserProvider>();
    return Container(
      color: CColors.White,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FutureBuilder<List>(
            future: _cookNowVM.getPosts(_userProvider.userInfo.uid),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  print("-Cook Now Tab- No Connection");
                  return Container();
                case ConnectionState.waiting:
                  print("-Cook Now Tab- waiting");
                  return Text('waiting');
                case ConnectionState.done:
                  if (snapshot.data!.isEmpty) {
                    print("-Cook Now Tab- has Error");
                    // showCustomDialog(context, "Error",
                    //     "An error has occurred.", "Okay", null);
                    return Container();
                  } else {
                    print("-Cook Now Tab- has Data");
                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data![1].docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 25.0,
                        mainAxisSpacing: 32.0,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.3),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        var _authorData = snapshot.data![0];
                        var _authorPostsData =
                            snapshot.data![1].docs[index].data();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => pushNewScreen(context,
                                  screen: UserProfileScreen(),
                                  withNavBar: false),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(11.0),
                                      child: CachedNetworkImage(
                                        imageUrl: _authorData["dpUrl"],
                                        imageBuilder: (context, image) {
                                          return Image(
                                            image: image,
                                            fit: BoxFit.fill,
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
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: CachedNetworkImage(
                                    imageUrl: _authorPostsData["postImageUrl"],
                                    imageBuilder: (context, image) {
                                      return Image(
                                        image: image,
                                        fit: BoxFit.fill,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                2.4,
                                      );
                                    },
                                    errorWidget: (context, str, dyn) {
                                      return Center(child: Icon(Icons.error));
                                    },
                                  )),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: CustomTextBold(
                                    text: _authorPostsData["postRecipeTitle"],
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: CustomTextMedium(
                                        text: "•",
                                        size: 12.0,
                                        color: CColors.SecondaryText),
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
                    );
                  }
                default:
                  return Container();
              }
            }),
      ),
    );
  }
}
