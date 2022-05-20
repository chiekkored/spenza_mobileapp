import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/filterProvider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/searchViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/utilities/constants/icons.dart';
import 'package:spenza/views/common/grids.dart';
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
  late Future<List> _loadSearch;

  @override
  void initState() {
    var _userProvider = context.read<UserProvider>();
    _loadSearch = _searchVM.getSearch(widget.searchText,
        _userProvider.userInfo.uid); // only create the future once.
    super.initState();
  }

  setSearchFilter(String result) {
    var _userProvider = context.read<UserProvider>();
    setState(() {
      _loadSearch =
          _searchVM.getSearch(widget.searchText, _userProvider.userInfo.uid);
      print(result);
    });
  }

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
                            onSubmitted: (text) {
                              if (_searchTextController.text == "") {
                                return null;
                              } else {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SearchResultScreen(
                                      searchText: text,
                                    ),
                                  ),
                                );
                              }
                            },
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                letterSpacing: 0.5,
                                color: CColors.MainText),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: CColors.Form,
                                suffixIcon: GestureDetector(
                                  onTap: (() =>
                                      _searchTextController.text = ""),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 11.0, right: 27.0),
                                    child: SvgPicture.asset(
                                        "assets/svg/clear.svg"),
                                  ),
                                ),
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
                                  return ModalBottomSheet(
                                    setSearchFilter: setSearchFilter,
                                  );
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
                  child: FutureBuilder<List>(
                      future: _loadSearch,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            print("-Search Results- No Connection");
                            return Container();
                          case ConnectionState.waiting:
                            print("-Search Results- waiting");
                            return CustomGridShimmer();
                          case ConnectionState.done:
                            if (snapshot.data!.isEmpty) {
                              print("-Search Results- has Error");
                              print(snapshot.data);
                              // return Container();
                              // showCustomDialog(context, "Error",
                              //     "An error has occurred.", "Okay", null);
                              return Expanded(
                                child: RefreshIndicator(
                                    onRefresh: () async {
                                      var _userProvider =
                                          context.read<UserProvider>();
                                      setState(() {
                                        _loadSearch = _searchVM.getSearch(
                                            widget.searchText,
                                            _userProvider.userInfo.uid);
                                      });
                                    },
                                    child: ListView(
                                        padding:
                                            const EdgeInsets.only(bottom: 24.0),
                                        shrinkWrap: true,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Image.asset(
                                                "assets/images/empty-face.png",
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    250,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16.0),
                                                child: CustomTextMedium(
                                                    text:
                                                        "Nothing to see here.",
                                                    size: 18.0,
                                                    color: CColors.PrimaryText),
                                              ),
                                            ],
                                          )
                                        ])),
                              );
                            } else {
                              print("-Search Results- has Data");
                              var filterProvider =
                                  context.read<FilterProvider>();
                              if (filterProvider.cookingDuration != 0.0 &&
                                  filterProvider.ingredientOnHand != 0.0) {
                                print("-----------in");
                                return RefreshIndicator(
                                  onRefresh: () async {
                                    setState(() {
                                      _loadSearch = _searchVM.getSearch(
                                          widget.searchText,
                                          _userProvider.userInfo.uid);
                                    });
                                  },
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      CustomGridViewWithFilter(
                                        snapshot: snapshot,
                                        fromScreen: "Search",
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                print("-----------out");
                                return RefreshIndicator(
                                  onRefresh: () async {
                                    setState(() {
                                      _loadSearch = _searchVM.getSearch(
                                          widget.searchText,
                                          _userProvider.userInfo.uid);
                                    });
                                  },
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      CustomGridView(
                                        snapshot: snapshot,
                                        fromScreen: "Search",
                                      )
                                    ],
                                  ),
                                );
                              }
                              ;
                            }
                          default:
                            return Container();
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
