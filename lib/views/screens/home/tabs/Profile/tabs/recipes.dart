import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/userProvider.dart';
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
    var _userProvider = context.read<UserProvider>().userInfo;
    _loadRecipes = _profileVM.getProfilePosts(_userProvider.uid, widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var _userProvider = context.read<UserProvider>().userInfo;
    return Container(
      padding: const EdgeInsets.only(bottom: 28.0),
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
                          _loadRecipes = _profileVM.getProfilePosts(
                              _userProvider.uid, widget.uid);
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
                        _loadRecipes = _profileVM.getProfilePosts(
                            _userProvider.uid, widget.uid);
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
