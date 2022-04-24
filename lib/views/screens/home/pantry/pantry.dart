import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/models/userModel.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/pantryViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/list.dart';
import 'package:spenza/views/common/texts.dart';

class PantryScreen extends StatefulWidget {
  const PantryScreen({Key? key}) : super(key: key);

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  PantryViewModel _pantryVM = PantryViewModel();
  late Future<QuerySnapshot> _getPantries;

  @override
  void initState() {
    UserModel _user = context.read<UserProvider>().userInfo;
    _getPantries = _pantryVM.getPantries(_user.uid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: CColors.White,
        child: FutureBuilder<QuerySnapshot>(
            future: _getPantries,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    print("-Pantry- has Error");
                    return CustomTextBold(
                        text: "Something went wrong.",
                        size: 15.0,
                        color: CColors.PrimaryText);
                  } else {
                    print("-Pantry- has Data");
                    return RefreshIndicator(
                      onRefresh: (() async {
                        setState(() {
                          UserModel _user =
                              context.read<UserProvider>().userInfo;
                          _getPantries = _pantryVM.getPantries(_user.uid);
                        });
                      }),
                      child: ListView.builder(
                        // shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            // return the header
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: new CustomTextBold(
                                  text: "Pantry",
                                  size: 24.0,
                                  color: CColors.PrimaryText),
                            );
                          }
                          index -= 1;
                          var pantryData = snapshot.data!.docs[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 24.0),
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
                            dense: false,
                          );
                        },
                      ),
                    );
                  }
                case ConnectionState.waiting:
                  print("-Pantry- waiting");
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
