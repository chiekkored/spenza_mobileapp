import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/utilities/constants/icons.dart';

import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/tabs/Profile/profile.dart';
import 'package:spenza/views/screens/home/tabs/home/home.dart';
import 'package:spenza/views/screens/home/tabs/notification/notification.dart';
import 'package:spenza/views/screens/home/tabs/recipe/recipe.dart';
import 'package:spenza/views/screens/home/tabs/scan/scan.dart';

// Navigating Scaffold at the same tab, use:
// pushNewScreen(withNavBar: true)
// or
// pushNewScreen(withNavBar: false)
//
// Reference: https://pub.dev/packages/persistent_bottom_nav_bar

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      navBarStyle: NavBarStyle.style15,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(0),
        colorBehindNavBar: Colors.white,
      ),
      screens: [
        HomeTab(),
        RecipeTab(),
        ScanTab(),
        NotificationTab(),
        ProfileTab()
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: Icon(CIcons.home),
          iconSize: 20,
          title: "Home",
          activeColorPrimary: CColors.PrimaryColor,
          inactiveColorPrimary: CColors.SecondaryText,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CIcons.recipe),
          iconSize: 20,
          title: "Recipe",
          activeColorPrimary: CColors.PrimaryColor,
          inactiveColorPrimary: CColors.SecondaryText,
        ),
        PersistentBottomNavBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Icon(CIcons.scan),
          ),
          iconSize: 20,
          title: "Scan",
          activeColorSecondary: Colors.white,
          activeColorPrimary: Colors.red,
          // inactiveColorPrimary: CColors.SecondaryText,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CIcons.notification),
          iconSize: 20,
          title: "Notification",
          activeColorPrimary: CColors.PrimaryColor,
          inactiveColorPrimary: CColors.SecondaryText,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CIcons.profile),
          iconSize: 20,
          title: "Profile",
          activeColorPrimary: CColors.PrimaryColor,
          inactiveColorPrimary: CColors.SecondaryText,
        ),
      ],
    );
  }
}
