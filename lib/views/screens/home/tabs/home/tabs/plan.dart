import 'package:flutter/material.dart';

class PlanTab extends StatefulWidget {
  const PlanTab({Key? key}) : super(key: key);

  @override
  _PlanTabState createState() => _PlanTabState();
}

class _PlanTabState extends State<PlanTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Text("Plan");
  }

  @override
  bool get wantKeepAlive => false;
}
