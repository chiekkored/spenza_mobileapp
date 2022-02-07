import 'package:flutter/material.dart';

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
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 27.0, right: 11.0),
                          child: Icon(Icons.search),
                        ),
                        CustomTextMedium(
                            text: "Search", size: 15, color: Colors.grey)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: CustomTextBold(
                        text: "Tags", size: 17.0, color: Colors.black),
                  )
                ],
              ),
            ),
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Recipe"),
              BottomNavigationBarItem(icon: Icon(null), label: "Scan"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.alarm), label: "Notification"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
            ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.document_scanner),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class CustomTextBold extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  const CustomTextBold(
      {Key? key, required this.text, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w700,
          fontSize: size,
          letterSpacing: 0.5,
          color: color),
    );
  }
}

class CustomTextMedium extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  const CustomTextMedium(
      {Key? key, required this.text, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w500,
          fontSize: size,
          letterSpacing: 0.5,
          color: color),
    );
  }
}
