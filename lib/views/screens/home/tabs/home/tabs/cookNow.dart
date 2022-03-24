import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/userProfile/userProfile.dart';

class CookNowTab extends StatefulWidget {
  const CookNowTab({Key? key}) : super(key: key);

  @override
  _CookNowTabState createState() => _CookNowTabState();
}

class _CookNowTabState extends State<CookNowTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CColors.White,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 25.0,
            mainAxisSpacing: 32.0,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.3),
          ),
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => pushNewScreen(context,
                      screen: UserProfileScreen(), withNavBar: false),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11.0),
                          child: Image.network(
                            "https://picsum.photos/200",
                            fit: BoxFit.fitHeight,
                            height: 31,
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomTextMedium(
                            text: "James Bond",
                            size: 12,
                            color: CColors.MainText),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: Image.network(
                      "https://picsum.photos/200",
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.width / 2.4,
                      loadingBuilder: (cxt, image, chunk) {
                        // print(chunk);
                        // if (chunk != null) {
                        //   return Shimmer.fromColors(
                        //       child: Text("shimmer"),
                        //       baseColor: Colors.red,
                        //       highlightColor: Colors.yellow);
                        // }
                        return image;
                      },
                      errorBuilder: (context, obj, stacktrace) {
                        return Center(child: Icon(Icons.error));
                      },
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: CustomTextBold(
                        text: "Pancake",
                        size: 17.0,
                        color: CColors.PrimaryText),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      CustomTextMedium(
                          text: "100%",
                          size: 12.0,
                          color: CColors.SecondaryText),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomTextMedium(
                            text: "•",
                            size: 12.0,
                            color: CColors.SecondaryText),
                      ),
                      CustomTextMedium(
                          text: "60 mins",
                          size: 12.0,
                          color: CColors.SecondaryText),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
