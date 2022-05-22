import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/postViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/grids.dart';
import 'package:spenza/views/common/texts.dart';

class RecipeTab extends StatefulWidget {
  const RecipeTab({Key? key}) : super(key: key);

  @override
  _RecipeTabState createState() => _RecipeTabState();
}

class _RecipeTabState extends State<RecipeTab> {
  PostViewModel _postVM = PostViewModel();
  late Future<List> _loadRecipes;
  @override
  void initState() {
    var _userProvider = context.read<UserProvider>();
    _loadRecipes = _postVM.getAllPosts(
        _userProvider.userInfo.uid); // only create the future once.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _userProvider = context.read<UserProvider>();
    return Container(
      color: CColors.White,
      child: FutureBuilder<List>(
          future: _loadRecipes,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                debugPrint("🚫 -Cook Now Tab- No Connection");
                return Container();
              case ConnectionState.waiting:
                debugPrint("⏳ -Cook Now Tab- waiting");
                return CustomGridShimmer();
              case ConnectionState.done:
                if (snapshot.data!.isEmpty) {
                  return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          _loadRecipes =
                              _postVM.getAllPosts(_userProvider.userInfo.uid);
                        });
                      },
                      child: ListView(
                          // physics: BouncingScrollPhysics(),
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
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _loadRecipes =
                            _postVM.getAllPosts(_userProvider.userInfo.uid);
                      });
                    },
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 16.0),
                          child: CustomTextBold(
                              text: "Recipe",
                              size: 32.0,
                              color: CColors.PrimaryText),
                        ),
                        CustomGridView(
                            snapshot: snapshot, fromScreen: "Recipe Tab"),
                      ],
                    ),
                  );
                }
              default:
                return Container();
            }
          }),
    );
  }
}
