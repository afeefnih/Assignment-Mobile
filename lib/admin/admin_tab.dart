import 'RegisteredUserPage.dart';
import 'BookingUsersPage.dart';
import 'package:flutter/material.dart';

class AdminTabView extends StatefulWidget {
  const AdminTabView({
    super.key,
  });
  final String title = "Flutter Bottom Tab demo";
  @override
  State<AdminTabView> createState() => _AdminTabViewState();
}

class _AdminTabViewState extends State<AdminTabView> {
  int currentTabIndex = 0;
  late List<Widget> tabs;

  @override
  void initState() {
    super.initState();
    tabs = [
      RegisteredUsersPage(),
      BookingUsersPage(),
      Container(color: const Color.fromARGB(255, 0, 0, 0)),
    ];
  }

  onTapped(int index) {
    if (index == 2) {
      _logOut();
    } else {
      setState(() {
        currentTabIndex = index;
      });
    }
  }

  void _logOut() {
    Navigator.popUntil(
      context,
      ModalRoute.withName('/'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.white,
        onTap: onTapped,
        currentIndex: currentTabIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "User List",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Booking List",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: "Logout",
          )
        ],
      ),
    );
  }
}
