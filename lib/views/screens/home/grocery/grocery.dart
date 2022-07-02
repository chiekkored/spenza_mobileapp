import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/models/userModel.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/profileViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/list.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/groceryPost/groceryPost.dart';
import 'package:spenza/views/screens/home/groceryPost/groceryPostEdit.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({Key? key}) : super(key: key);

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  ProfileViewModel _profileVM = ProfileViewModel();
  late Stream<QuerySnapshot> _getGrocery;

  @override
  void initState() {
    UserModel _user = context.read<UserProvider>().userInfo;
    _getGrocery = _profileVM.getGroceries(_user.uid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel _user = context.read<UserProvider>().userInfo;
    return Material(
      child: Container(
        color: CColors.White,
        child: StreamBuilder<QuerySnapshot>(
            stream: _getGrocery,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                debugPrint("🚫 -Grocery- has Error");
                return CustomTextBold(
                    text: "Something went wrong.",
                    size: 15.0,
                    color: CColors.PrimaryText);
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                debugPrint("⏳ -Grocery- waiting");
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: CustomListShimmer(),
                );
              }
              debugPrint("🟢 -Grocery- has Data");
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    var groceryData = snapshot.data!.docs[index];
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 2,
                            onPressed: (context) => pushNewScreen(context,
                                screen: GroceryPostEditScreen(
                                    docId: groceryData.id,
                                    image: groceryData["groceryImageUrl"],
                                    foodNameText:
                                        groceryData["groceryFoodTitle"],
                                    quanitityText:
                                        groceryData["groceryQuantity"],
                                    unitText: groceryData["groceryUnit"]),
                                withNavBar: false),
                            backgroundColor: CColors.PrimaryColor,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (context) async {
                              await _profileVM.deleteGrocery(
                                  _user.uid, groceryData.id);
                            },
                            backgroundColor: CColors.SecondaryColor,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: CheckboxListTile(
                        value: groceryData["groceryIsDone"],
                        onChanged: (value) async {
                          dynamic result = await _profileVM.toggleGroceryItem(
                              _user.uid, groceryData.id, value!);
                          print(result);
                        },
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 24.0),
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        secondary: Container(
                          height: 50.0,
                          width: 50.0,
                          child: CachedNetworkImage(
                            imageUrl: groceryData["groceryImageUrl"],
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
                            text: groceryData["groceryFoodTitle"],
                            size: 16.0,
                            color: CColors.MainText),
                        subtitle: CustomTextRegular(
                            text:
                                "${groceryData["groceryQuantity"]} ${groceryData["groceryUnit"]}",
                            size: 14.0,
                            color: CColors.SecondaryText),
                        dense: true,
                      ),
                    );
                  },
                ),
              );
            }),
      ),
    );
  }
}
