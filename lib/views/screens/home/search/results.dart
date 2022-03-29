import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/searchViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/utilities/constants/icons.dart';
import 'package:spenza/views/common/popovers.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/userProfile/userProfile.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchText;
  const SearchResultScreen({Key? key, required this.searchText})
      : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  SearchViewModel _searchVM = SearchViewModel();
  @override
  Widget build(BuildContext context) {
    var _userProvider = context.read<UserProvider>();
    TextEditingController _searchTextController =
        TextEditingController(text: widget.searchText);
    return Container(
      color: CColors.White,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: CColors.White,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 23.0, 24.0, 23.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Icon(
                              CIcons.back,
                              color: CColors.MainText,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchTextController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (text) =>
                                Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SearchResultScreen(
                                  searchText: text,
                                ),
                              ),
                            ),
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                letterSpacing: 0.5,
                                color: CColors.MainText),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: CColors.Form,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 27.0, right: 11.0),
                                  child: Icon(
                                    CIcons.search,
                                    color: CColors.SecondaryText,
                                  ),
                                ),
                                hintText: "Search",
                                hintStyle: TextStyle(
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    letterSpacing: 0.5,
                                    color: CColors.SecondaryText),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(32.0),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: GestureDetector(
                            onTap: () => showModalBottomSheet(
                                isScrollControlled: true,
                                useRootNavigator: true,
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(32.0),
                                    topRight: const Radius.circular(32.0),
                                  ),
                                ),
                                builder: (BuildContext builder) {
                                  return ModalBottomSheet();
                                }),
                            child: SvgPicture.asset(
                              "assets/svg/settings.svg",
                              height: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.0),
                  color: CColors.White,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                      child: FutureBuilder<List>(
                          future: _searchVM.getSearch(
                              widget.searchText, _userProvider.userInfo.uid),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                print("-Search Results- No Connection");
                                return Container();
                              case ConnectionState.waiting:
                                print("-Search Results- waiting");
                                return Text('waiting');
                              case ConnectionState.done:
                                if (snapshot.data!.isEmpty) {
                                  print("-Search Results- has Error");
                                  // showCustomDialog(context, "Error",
                                  //     "An error has occurred.", "Okay", null);
                                  return Container();
                                } else {
                                  print("-Search Results- has Data");
                                  return GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data![1].docs.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 25.0,
                                      mainAxisSpacing: 32.0,
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .width /
                                          (MediaQuery.of(context).size.height /
                                              1.3),
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var _authorData = snapshot.data![0];
                                      var _authorPostsData =
                                          snapshot.data![1].docs[index].data();
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () => pushNewScreen(context,
                                                screen: UserProfileScreen(),
                                                withNavBar: false),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            11.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          _authorData["dpUrl"],
                                                      imageBuilder:
                                                          (context, image) {
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
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                                child: CachedNetworkImage(
                                                  imageUrl: _authorPostsData[
                                                      "postImageUrl"],
                                                  imageBuilder:
                                                      (context, image) {
                                                    return Image(
                                                      image: image,
                                                      fit: BoxFit.fill,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.4,
                                                    );
                                                  },
                                                  errorWidget:
                                                      (context, str, dyn) {
                                                    return Center(
                                                        child:
                                                            Icon(Icons.error));
                                                  },
                                                )),
                                          ),
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16.0),
                                              child: CustomTextBold(
                                                  text: _authorPostsData[
                                                      "postRecipeTitle"],
                                                  size: 17.0,
                                                  color: CColors.PrimaryText),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Row(
                                              children: [
                                                CustomTextMedium(
                                                    text: _authorPostsData[
                                                        "postPercent"],
                                                    size: 12.0,
                                                    color:
                                                        CColors.SecondaryText),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: CustomTextMedium(
                                                      text: "•",
                                                      size: 12.0,
                                                      color: CColors
                                                          .SecondaryText),
                                                ),
                                                CustomTextMedium(
                                                    text: _authorPostsData[
                                                        "postDuration"],
                                                    size: 12.0,
                                                    color:
                                                        CColors.SecondaryText),
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
                          })),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
