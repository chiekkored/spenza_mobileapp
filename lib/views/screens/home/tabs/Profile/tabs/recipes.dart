import 'package:flutter/material.dart';
import 'package:spenza/core/viewmodels/postViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/grids.dart';
import 'package:spenza/views/common/texts.dart';

class RecipesTab extends StatefulWidget {
  final String uid;
  const RecipesTab({Key? key, required this.uid}) : super(key: key);

  @override
  State<RecipesTab> createState() => _RecipesTabState();
}

class _RecipesTabState extends State<RecipesTab>
    with AutomaticKeepAliveClientMixin {
  PostViewModel _profileVM = PostViewModel();
  late Future<List<Map<String, dynamic>>> _loadRecipes;

  @override
  void initState() {
    _loadRecipes =
        _profileVM.getProfilePosts(widget.uid); // only create the future once.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      color: CColors.White,
      child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _loadRecipes,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                debugPrint("🚫 -Profile Recipes- No Connection");
                return Container();
              case ConnectionState.waiting:
                debugPrint("⏳ -Profile Recipes- waiting");
                return CustomGridShimmerWithoutDp();
              case ConnectionState.done:
                if (snapshot.data!.isEmpty) {
                  debugPrint("🚫 -Profile Recipes- has Error");
                  return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          _loadRecipes = _profileVM.getProfilePosts(widget.uid);
                        });
                      },
                      child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/empty-face.png",
                                  width:
                                      MediaQuery.of(context).size.width - 250,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: CustomTextMedium(
                                      text: "Nothing to see here.",
                                      size: 18.0,
                                      color: CColors.SecondaryText),
                                ),
                              ],
                            )
                          ]));
                } else {
                  debugPrint("🟢 -Profile Recipes- has Data");
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _loadRecipes = _profileVM.getProfilePosts(widget.uid);
                      });
                    },
                    child: CustomGridViewWithoutDp(
                      snapshot: snapshot,
                      fromScreen: "receipes",
                    ),
                  );
                }
              default:
                return Container();
            }
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
