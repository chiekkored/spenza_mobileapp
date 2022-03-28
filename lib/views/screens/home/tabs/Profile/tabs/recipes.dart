import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/profileViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/texts.dart';

class RecipesTab extends StatefulWidget {
  const RecipesTab({Key? key}) : super(key: key);

  @override
  State<RecipesTab> createState() => _RecipesTabState();
}

class _RecipesTabState extends State<RecipesTab> {
  @override
  Widget build(BuildContext context) {
    ProfileViewModel _profileVM = ProfileViewModel();
    var _userProvider = context.read<UserProvider>();
    return Container(
      color: CColors.White,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FutureBuilder<QuerySnapshot>(
            future: _profileVM.getPosts(_userProvider.userInfo.uid),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  print("-Cook Now Tab- No Connection");
                  return Container();
                case ConnectionState.waiting:
                  print("-Cook Now Tab- waiting");
                  return Text('waiting');
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    print("-Cook Now Tab- has Error");
                    // showCustomDialog(context, "Error",
                    //     "An error has occurred.", "Okay", null);
                    return Container();
                  } else {
                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 25.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.4),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        var _postData = snapshot.data!.docs[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.0),
                                  child: CachedNetworkImage(
                                    imageUrl: _postData["postImageUrl"],
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
                                    text: _postData["postRecipeTitle"],
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: CustomTextMedium(
                                        text: "•",
                                        size: 12.0,
                                        color: CColors.SecondaryText),
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
