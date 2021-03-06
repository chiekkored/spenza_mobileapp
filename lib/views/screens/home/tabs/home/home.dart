import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_button/group_button.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/filterProvider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/postViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/utilities/constants/icons.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/grids.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/grocery/grocery.dart';
import 'package:spenza/views/screens/home/pantry/pantry.dart';
import 'package:spenza/views/screens/home/search/search.dart';
import 'package:spenza/views/screens/home/tabs/home/tabs/plan.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  PostViewModel _postVM = PostViewModel();
  late Future<List> _loadCookNow;

  FirebaseAuth _user = FirebaseAuth.instance;
  GroupButtonController _tagSelectedController =
      GroupButtonController(selectedIndex: 0);

  @override
  void initState() {
    // var _userProvider = context.read<UserProvider>();
    _loadCookNow = _postVM.getPosts(_user.currentUser!.uid,
        context.read<FilterProvider>()); // only create the future once.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var filterProvider = context.read<FilterProvider>();
    return Material(
      type: MaterialType.transparency,
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: Container(
                  color: CColors.White,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 23.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  pushNewScreen(context,
                                      screen: PantryScreen());
                                },
                                icon: Icon(
                                  Icons.food_bank,
                                  size: 35.0,
                                  color: CColors.MainText,
                                ),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => pushNewScreen(context,
                                      screen: SearchScreen()),
                                  child: Container(
                                    height: 56.0,
                                    decoration: BoxDecoration(
                                      color: CColors.Form,
                                      borderRadius: BorderRadius.circular(32.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 27.0, right: 11.0),
                                            child: Icon(
                                              CIcons.search,
                                              color: CColors.SecondaryText,
                                            )),
                                        CustomTextMedium(
                                            text: "Search",
                                            size: 15,
                                            color: CColors.SecondaryText)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  pushNewScreen(context,
                                      screen: GroceryScreen());
                                },
                                icon: Icon(
                                  Icons.add_shopping_cart,
                                  color: CColors.MainText,
                                  size: 35.0,
                                ),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: CustomTextBold(
                                    text: "Tags",
                                    size: 17.0,
                                    color: CColors.PrimaryText),
                              ),
                              SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: GroupButton(
                                        controller: _tagSelectedController,
                                        isRadio: true,
                                        onSelected: (str, index, isSelected) {
                                          HapticFeedback.selectionClick();
                                          var _userProvider =
                                              context.read<UserProvider>();
                                          filterProvider.filterSet(
                                              str.toString() == "All"
                                                  ? ""
                                                  : str.toString(),
                                              0,
                                              100,
                                              60);
                                          setState(() {
                                            _loadCookNow = _postVM.getPosts(
                                                _userProvider.userInfo.uid,
                                                filterProvider);
                                          });
                                        },
                                        options: customGroupButtonOptions(),
                                        buttons: ["All", "Food", "Drink"],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 8.0,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                      color: CColors.White,
                      border:
                          Border(bottom: BorderSide(color: CColors.Outline))),
                  child: TabBar(
                      indicatorColor: CColors.PrimaryColor,
                      labelColor: CColors.PrimaryText,
                      unselectedLabelColor: CColors.SecondaryText,
                      indicatorWeight: 3.0,
                      labelStyle: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                      tabs: [
                        Tab(
                          text: "Cook now",
                        ),
                        Tab(
                          text: "Plan",
                        )
                      ]),
                ),
              ),
            ];
          },
          body: TabBarView(children: [
            StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return Container(
                  color: CColors.White,
                  child: FutureBuilder<List>(
                      future: _loadCookNow,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            debugPrint("???? -Cook Now Tab- No Connection");
                            return Container();
                          case ConnectionState.waiting:
                            debugPrint("??? -Cook Now Tab- waiting");
                            return CustomGridShimmer();
                          case ConnectionState.done:
                            if (snapshot.data!.isEmpty) {
                              debugPrint("???? -Cook Now Tab- has Error");
                              return RefreshIndicator(
                                  onRefresh: () async {
                                    var _userProvider =
                                        context.read<UserProvider>();
                                    setState(() {
                                      _loadCookNow = _postVM.getPosts(
                                          _userProvider.userInfo.uid,
                                          filterProvider);
                                    });
                                  },
                                  child: ListView(
                                      physics: BouncingScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 24.0),
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
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
                                                  text: "Nothing to see here.",
                                                  size: 18.0,
                                                  color: CColors.SecondaryText),
                                            ),
                                          ],
                                        )
                                      ]));
                            } else {
                              debugPrint("???? -Cook Now Tab- has Data");
                              return RefreshIndicator(
                                onRefresh: () async {
                                  var _userProvider =
                                      context.read<UserProvider>();
                                  setState(() {
                                    _loadCookNow = _postVM.getPosts(
                                        _userProvider.userInfo.uid,
                                        filterProvider);
                                  });
                                },
                                child: CustomGridView(
                                  snapshot: snapshot,
                                  fromScreen: "Home",
                                ),
                              );
                            }
                          default:
                            return Container();
                        }
                      }),
                );
              },
            ),
            PlanTab(),
          ]),
        ),
      ),
    );
  }
}
