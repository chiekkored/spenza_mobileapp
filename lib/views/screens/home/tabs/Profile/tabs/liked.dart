import 'package:flutter/material.dart';

class LikedTab extends StatefulWidget {
  const LikedTab({Key? key}) : super(key: key);

  @override
  State<LikedTab> createState() => _LikedTabState();
}

class _LikedTabState extends State<LikedTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container();
  }

  @override
  bool get wantKeepAlive => true;
}
