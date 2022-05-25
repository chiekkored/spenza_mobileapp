import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/models/userModel.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/profileViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/list.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PantryScreen extends StatefulWidget {
  const PantryScreen({Key? key}) : super(key: key);

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  ProfileViewModel _profileVM = ProfileViewModel();
  late Stream<QuerySnapshot> _getPantries;

  @override
  void initState() {
    UserModel _user = context.read<UserProvider>().userInfo;
    _getPantries = _profileVM.getPantries(_user.uid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel _user = context.read<UserProvider>().userInfo;
    return Material(
      child: Container(
        color: CColors.White,
        child: StreamBuilder<QuerySnapshot>(
            stream: _getPantries,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                debugPrint("🚫 -Pantry- has Error");
                return CustomTextBold(
                    text: "Something went wrong.",
                    size: 15.0,
                    color: CColors.PrimaryText);
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                debugPrint("⏳ -Pantry- waiting");
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: CustomListShimmer(),
                );
              }
              debugPrint("🟢 -Pantry- has Data");
              return RefreshIndicator(
                onRefresh: (() async {
                  setState(() {
                    UserModel _user = context.read<UserProvider>().userInfo;
                    _getPantries = _profileVM.getPantries(_user.uid);
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
                        child: new CustomTextBold(
                            text: "Pantry",
                            size: 32.0,
                            color: CColors.PrimaryText),
                      );
                    }
                    index -= 1;
                    var pantryData = snapshot.data!.docs[index];
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          // SlidableAction(
                          //   // An action can be bigger than the others.
                          //   flex: 2,
                          //   onPressed: (context) {},
                          //   backgroundColor: CColors.PrimaryColor,
                          //   foregroundColor: Colors.white,
                          //   icon: Icons.edit,
                          //   label: 'Edit',
                          // ),
                          SlidableAction(
                            onPressed: (context) async {
                              await _profileVM.deletePantry(
                                  _user.uid, pantryData.id);
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
                        visualDensity: VisualDensity.adaptivePlatformDensity,
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
            }),
      ),
    );
  }
}
