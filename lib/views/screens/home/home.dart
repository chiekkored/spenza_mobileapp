import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spenza/utilities/constants/colors.dart';

import 'package:spenza/views/common/texts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 23.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 56.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: CColors.Form,
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 27.0, right: 11.0),
                          child: SvgPicture.asset("assets/svg/search.svg"),
                        ),
                        CustomTextMedium(
                            text: "Search",
                            size: 15,
                            color: CColors.SecondaryText)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: CustomTextBold(
                        text: "Tags", size: 17.0, color: CColors.PrimaryText),
                  )
                ],
              ),
            ),
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            selectedLabelStyle: TextStyle(
              fontFamily: "Inter",
              fontWeight: FontWeight.w500,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: "Inter",
              fontWeight: FontWeight.w500,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
            selectedItemColor: CColors.PrimaryColor,
            unselectedItemColor: CColors.SecondaryText,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
                    child: SvgPicture.asset("assets/svg/home.svg"),
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
                    child: SvgPicture.asset("assets/svg/recipe.svg"),
                  ),
                  label: "Recipe"),
              BottomNavigationBarItem(icon: Icon(null), label: "Scan"),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
                    child: SvgPicture.asset("assets/svg/notification.svg"),
                  ),
                  label: "Notification"),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
                    child: SvgPicture.asset("assets/svg/profile.svg"),
                  ),
                  label: "Profile"),
            ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: CColors.SecondaryColor,
          onPressed: () {},
          child: SvgPicture.asset("assets/svg/scan.svg"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
