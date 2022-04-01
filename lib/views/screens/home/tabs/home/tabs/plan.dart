import 'package:flutter/material.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/texts.dart';

class PlanTab extends StatefulWidget {
  const PlanTab({Key? key}) : super(key: key);

  @override
  _PlanTabState createState() => _PlanTabState();
}

class _PlanTabState extends State<PlanTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: CColors.White,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/rocket.png",
              width: MediaQuery.of(context).size.width - 250,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: CustomTextMedium(
                  text: "Coming soon",
                  size: 18.0,
                  color: CColors.SecondaryText),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
