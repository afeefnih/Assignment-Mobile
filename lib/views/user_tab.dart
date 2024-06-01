import 'package:flutter/material.dart';
import 'package_view.dart';
import '/views/profile.dart';



class TabView extends StatefulWidget {
  const TabView({super.key, required this.id});
  final String title = "Flutter Bottom Tab demo";
  final int id;
  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {

  int currentTabIndex = 0;
  late List<Widget> tabs;

  @override
  void initState() {
    super.initState();
    tabs = [
      PackageView(id: widget.id),
      Container(color: Colors.green),
      ProfileTab(id: widget.id),
    ];
  }
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
