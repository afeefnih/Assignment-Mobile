import 'package:flutter/material.dart';
import 'booking_list.dart';
import '../views/package_view.dart';
import 'profile_view.dart';



class TabView extends StatefulWidget {
  const TabView({super.key, required this.id, this.tabIndex});
  final String title = "Flutter Bottom Tab demo";
  final int id;
  final int? tabIndex;
  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {

  int currentTabIndex = 0;
  late List<Widget> tabs;

  @override
  void initState() {
    super.initState();
    currentTabIndex = widget.tabIndex ?? 0;
    tabs = [
      PackageViewUser(id: widget.id),
      BookingTab(id: widget.id),
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
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.white,
        onTap: onTapped,
        currentIndex: currentTabIndex,
        items: const [
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


class PackageViewUser extends StatelessWidget {
  const PackageViewUser({super.key, this.id});
final int? id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homestay Package'),
        automaticallyImplyLeading: false,
      ),
      body: PackageContent(id: id,),
    );
  }
}