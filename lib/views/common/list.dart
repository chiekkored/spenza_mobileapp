import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spenza/utilities/constants/colors.dart';

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