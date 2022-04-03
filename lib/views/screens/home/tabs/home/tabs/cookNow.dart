import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/cookNowViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/grids.dart';
import 'package:spenza/views/common/popovers.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/userProfile/userProfile.dart';

class CookNowTab extends StatefulWidget {
  const CookNowTab({Key? key}) : super(key: key);

  @override
  _CookNowTabState createState() => _CookNowTabState();
}

class _CookNowTabState extends State<CookNowTab>
    with AutomaticKeepAliveClientMixin {
  CookNowViewModel _cookNowVM = CookNowViewModel();
  late Future<List> _loadCookNow;

  FirebaseAuth _user = FirebaseAuth.instance;
  @override
  void initState() {
    // var _userProvider = context.read<UserProvider>();
    _loadCookNow = _cookNowVM
        .getPosts(_user.currentUser!.uid); // only create the future once.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: CColors.White,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FutureBuilder<List>(
            future: _loadCookNow,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  print("-Cook Now Tab- No Connection");
                  return Container();
                case ConnectionState.waiting:
                  print("-Cook Now Tab- waiting");
                  return CustomGridShimmer();
                case ConnectionState.done:
                  if (snapshot.data!.isEmpty) {
                    print("-Cook Now Tab- has Error");
                    print(snapshot.data);
                    // showCustomDialog(context, "Error",
                    //     "An error has occurred.", "Okay", null);
                    return RefreshIndicator(
                        onRefresh: () async {
                          var _userProvider = context.read<UserProvider>();
                          setState(() {
                            _loadCookNow =
                                _cookNowVM.getPosts(_userProvider.userInfo.uid);
                          });
                        },
                        child: ListView(
                            physics: BouncingScrollPhysics(),
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
                    print("-Cook Now Tab- has Data");
                    print(snapshot.data);
                    return RefreshIndicator(
                      onRefresh: () async {
                        var _userProvider = context.read<UserProvider>();
                        setState(() {
                          _loadCookNow =
                              _cookNowVM.getPosts(_userProvider.userInfo.uid);
                        });
                      },
                      child: CustomGridView(snapshot: snapshot),
                    );
                  }
                default:
                  print("-Cook Now Tab- default");
                  return Container();
              }
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
