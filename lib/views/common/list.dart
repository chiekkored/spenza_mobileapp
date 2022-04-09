import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/texts.dart';

class CustomListShimmer extends StatelessWidget {
  const CustomListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CColors.Form,
      highlightColor: CColors.White,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (_, __) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 17.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 120.0,
                            height: 8.0,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class CustomNotificationListShimmer extends StatelessWidget {
  const CustomNotificationListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CColors.Form,
      highlightColor: CColors.White,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 6,
          itemBuilder: (_, __) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 17.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 120.0,
                              height: 12.0,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 120.0,
                              height: 12.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class CustomRecipeDetailListShimmer extends StatelessWidget {
  const CustomRecipeDetailListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextBold(
            text: "Description", size: 17.0, color: CColors.PrimaryText),
        Shimmer.fromColors(
          baseColor: CColors.Form,
          highlightColor: CColors.White,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (_, __) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: [
                      Container(
                        width: 100.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(
            thickness: 1.0,
          ),
        ),
        CustomTextBold(
            text: "Ingredients", size: 17.0, color: CColors.PrimaryText),
      ],
    );
  }
}
