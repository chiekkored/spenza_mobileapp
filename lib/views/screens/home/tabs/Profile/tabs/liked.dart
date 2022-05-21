import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/viewmodels/postViewModels.dart';
import 'package:spenza/core/viewmodels/profileViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/grids.dart';
import 'package:spenza/views/common/texts.dart';

class LikedTab extends StatefulWidget {
  final String uid;
  const LikedTab({Key? key, required this.uid}) : super(key: key);

  @override
  State<LikedTab> createState() => _LikedTabState();
}

class _LikedTabState extends State<LikedTab>
    with AutomaticKeepAliveClientMixin {
  PostViewModel _postVM = PostViewModel();
  late Future<List> _loadLikes;

  @override
  void initState() {
    _loadLikes =
        _postVM.getProfileLikes(widget.uid); // only create the future once.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: CColors.White,
      child: FutureBuilder<List>(
          future: _loadLikes,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                debugPrint("🚫-Profile Likes- No Connection");
                return Container();
              case ConnectionState.waiting:
                debugPrint("⏳ -Profile Likes- waiting");
                return CustomGridShimmerWithoutDp();
              case ConnectionState.done:
                if (snapshot.data!.isEmpty) {
                  debugPrint("🚫 -Profile Likes- has Error");
                  return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          _loadLikes = _postVM.getProfileLikes(widget.uid);
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
                  debugPrint("🟢 -Profile Likes- has Data");
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _loadLikes = _postVM.getProfileLikes(widget.uid);
                      });
                    },
                    child: CustomGridView(
                      snapshot: snapshot,
                      fromScreen: "liked",
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
