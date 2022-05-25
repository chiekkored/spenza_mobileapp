import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_button/group_button.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/filterProvider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/searchViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/utilities/constants/icons.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/list.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/search/results.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _searchTextController = TextEditingController();
  SearchViewModel _searchVM = SearchViewModel();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var _userProvider = context.read<UserProvider>();
    return Container(
      color: CColors.White,
      margin: const EdgeInsets.only(bottom: 40.0),
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
                            autofocus: true,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (text) {
                              if (_searchTextController.text == "") {
                                return null;
                              } else {
                                var filterProvider =
                                    context.read<FilterProvider>();
                                filterProvider.filterSet("", 0, 0.0, 0.0);
                                pushNewScreen(context,
                                    screen: SearchResultScreen(
                                        searchText:
                                            _searchTextController.text));
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
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 24.0),
                        //   child: GestureDetector(
                        //     onTap: () => showModalBottomSheet(
                        //         isScrollControlled: true,
                        //         useRootNavigator: true,
                        //         context: context,
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.only(
                        //             topLeft: const Radius.circular(32.0),
                        //             topRight: const Radius.circular(32.0),
                        //           ),
                        //         ),
                        //         builder: (BuildContext builder) {
                        //           return ModalBottomSheet();
                        //         }),
                        //     child: SvgPicture.asset(
                        //       "assets/svg/settings.svg",
                        //       height: 24,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.0),
                  color: CColors.White,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                    child: FutureBuilder<QuerySnapshot>(
                        future: _searchVM
                            .getSearchHistory(_userProvider.userInfo.uid),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              debugPrint("🚫 -Search History- No Connection");
                              return Container();
                            case ConnectionState.waiting:
                              debugPrint("⏳ -Search History- waiting");
                              return CustomListShimmer();
                            case ConnectionState.done:
                              if (snapshot.data!.docs.isEmpty) {
                                debugPrint("🚫 -Search History- has Error");
                                // showCustomDialog(context, "Error",
                                //     "An error has occurred.", "Okay", null);
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: CustomTextMedium(
                                          text: "No search results",
                                          size: 18.0,
                                          color: CColors.SecondaryText),
                                    ),
                                  ],
                                );
                              } else {
                                debugPrint("🟢 -Search History- has Data");
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      var _searchData =
                                          snapshot.data!.docs[index];
                                      return GestureDetector(
                                        onTap: () => _searchTextController
                                            .text = _searchData["searchText"],
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 24.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/svg/time.svg",
                                                    // height: 24,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 17.0),
                                                    child: CustomTextMedium(
                                                        text: _searchData[
                                                            "searchText"],
                                                        size: 17,
                                                        color: CColors
                                                            .PrimaryText),
                                                  )
                                                ],
                                              ),
                                              Icon(
                                                CIcons.arrow_upward,
                                                size: 14.0,
                                                color: CColors.SecondaryText,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }
                            default:
                              return Container();
                          }
                        }),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.0),
                  padding: EdgeInsets.all(24.0),
                  width: MediaQuery.of(context).size.width,
                  color: CColors.White,
                  child: GroupButton(
                    isRadio: true,
                    onSelected: (str, index, isSelected) =>
                        _searchTextController.text = str.toString(),
                    options: customGroupButtonOptions(),
                    buttons: ["sushi", "breakfast", "seafood", "fried rice"],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
