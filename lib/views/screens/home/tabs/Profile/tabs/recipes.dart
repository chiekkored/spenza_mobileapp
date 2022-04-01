import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/profileViewModels.dart';
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
  ProfileViewModel _profileVM = ProfileViewModel();
  late Future<QuerySnapshot> _loadRecipes;

  @override
  void initState() {
    _loadRecipes =
        _profileVM.getPosts(widget.uid); // only create the future once.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      color: CColors.White,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FutureBuilder<QuerySnapshot>(
            future: _loadRecipes,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  print("-Profile Recipes- No Connection");
                  return Container();
                case ConnectionState.waiting:
                  print("-Profile Recipes- waiting");
                  return CustomGridShimmerWithoutDp();
                case ConnectionState.done:
                  if (snapshot.data!.docs.isEmpty) {
                    print("-Profile Recipes- has Error");
                    print(snapshot.data);
                    // showCustomDialog(context, "Error",
                    //     "An error has occurred.", "Okay", null);
                    return RefreshIndicator(
                        onRefresh: () async {
                          setState(() {
                            _loadRecipes = _profileVM.getPosts(widget.uid);
                          });
                        },
                        child: ListView(
                            padding: const EdgeInsets.only(bottom: 24.0),
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
                    print("-Profile Recipes- has Data");
                    print(snapshot.data);
                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          _loadRecipes = _profileVM.getPosts(widget.uid);
                        });
                      },
                      child: CustomGridViewWithoutDp(snapshot: snapshot),
                    );
                  }
                default:
                  return Container();
              }
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
