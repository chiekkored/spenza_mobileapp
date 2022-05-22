import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/models/userModel.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/pantryViewModels.dart';
import 'package:spenza/core/viewmodels/profileViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/list.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/groceryPost/groceryPost.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({Key? key}) : super(key: key);

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  ProfileViewModel _groceryVM = ProfileViewModel();
  late Future<QuerySnapshot> _getGrocery;

  @override
  void initState() {
    UserModel _user = context.read<UserProvider>().userInfo;
    _getGrocery = _groceryVM.getGroceries(_user.uid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: CColors.White,
        child: FutureBuilder<QuerySnapshot>(
            future: _getGrocery,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    debugPrint("🚫 -Pantry- has Error");
                    return CustomTextBold(
                        text: "Something went wrong.",
                        size: 15.0,
                        color: CColors.PrimaryText);
                  } else {
                    debugPrint("🟢 -Pantry- has Data");
                    return RefreshIndicator(
                      onRefresh: (() async {
                        setState(() {
                          // UserModel _user =
                          //     context.read<UserProvider>().userInfo;
                          // _getPantries = _pantryVM.getPantries(_user.uid);
                        });
                      }),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(0.0),
                        separatorBuilder: (context, index) {
                          if (index == 0) {
                            // return the header
                            return Container();
                          }
                          return Divider();
                        },
                        // shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            // return the header
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomTextBold(
                                      text: "Grocery",
                                      size: 32.0,
                                      color: CColors.PrimaryText),
                                  TextButton(
                                    onPressed: () => pushNewScreen(context,
                                        withNavBar: false,
                                        screen: GroceryPostScreen()),
                                    child: Container(
                                      height: 35.0,
                                      width: 35.0,
                                      decoration: BoxDecoration(
                                          color: CColors.PrimaryColor,
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.add,
                                        color: CColors.White,
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                          index -= 1;
                          var pantryData = snapshot.data!.docs[index];
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  // An action can be bigger than the others.
                                  flex: 2,
                                  onPressed: (context) {},
                                  backgroundColor: CColors.PrimaryColor,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    snapshot.data!.docs.removeAt(index);
                                  },
                                  backgroundColor: CColors.SecondaryColor,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              visualDensity:
                                  VisualDensity.adaptivePlatformDensity,
                              leading: Container(
                                height: 50.0,
                                width: 50.0,
                                child: CachedNetworkImage(
                                  imageUrl: pantryData["pantryImageUrl"],
                                  imageBuilder: (context, image) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: Image(
                                        image: image,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              title: CustomTextMedium(
                                  text: pantryData["pantryFoodTitle"],
                                  size: 16.0,
                                  color: CColors.MainText),
                              subtitle: CustomTextRegular(
                                  text:
                                      "${pantryData["pantryQuantity"]} ${pantryData["pantryUnit"]}",
                                  size: 14.0,
                                  color: CColors.SecondaryText),
                              dense: true,
                            ),
                          );
                        },
                      ),
                    );
                  }
                case ConnectionState.waiting:
                  debugPrint("⏳ -Pantry- waiting");
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: CustomListShimmer(),
                  );
                default:
                  return CustomTextBold(
                      text: "Something went wrong.",
                      size: 15.0,
                      color: CColors.PrimaryText);
              }
            }),
      ),
    );
  }
}
