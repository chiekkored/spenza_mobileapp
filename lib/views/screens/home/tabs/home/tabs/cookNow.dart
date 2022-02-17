import 'package:flutter/material.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/texts.dart';

class CookNowTab extends StatefulWidget {
  const CookNowTab({Key? key}) : super(key: key);

  @override
  _CookNowTabState createState() => _CookNowTabState();
}

class _CookNowTabState extends State<CookNowTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 25.0,
          mainAxisSpacing: 32.0,
          childAspectRatio: 0.61,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 31.0,
                    width: 31.0,
                    margin: EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11.0),
                      image: DecorationImage(
                        image: NetworkImage("https://picsum.photos/200"),
                      ),
                    ),
                  ),
                  CustomTextMedium(
                      text: "James Bond", size: 12, color: CColors.MainText)
                ],
              ),
              Container(
                height: 151.0,
                width: 151.0,
                margin: EdgeInsets.only(top: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  image: DecorationImage(
                    image: NetworkImage("https://picsum.photos/200"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CustomTextBold(
                    text: "Pancake", size: 17.0, color: CColors.PrimaryText),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    CustomTextMedium(
                        text: "100%", size: 12.0, color: CColors.SecondaryText),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomTextMedium(
                          text: "•", size: 12.0, color: CColors.SecondaryText),
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
    );
  }
}
