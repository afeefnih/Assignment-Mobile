import 'package:assignment1/models/userId.dart';
import 'package:flutter/material.dart';
import '/booking_page_2.dart';
import '/views/profile.dart';



class TabView extends StatefulWidget {
  const TabView({super.key});
  final String title = "Flutter Bottom Tab demo";

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {

  int currentTabIndex = 0;
  List<Widget> tabs = [
    const BookingPage2(),
    Container(color: Colors.green),
    ProfileTab()
  ];
  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Booking",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          )
        ],
      ),
    );
  }
}
