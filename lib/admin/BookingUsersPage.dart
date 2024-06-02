import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'RegisteredUserPage.dart';
import '../main.dart';

class BookingUsersPage extends StatefulWidget {
  @override
  _BookingUsersPageState createState() => _BookingUsersPageState();
}

class _BookingUsersPageState extends State<BookingUsersPage> {
  List<Map<String, dynamic>> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<Map<String, dynamic>> bookings = await db.getBookings();
    setState(() {
      _bookings = bookings;
    });
  }

  void _viewRegisteredUsers() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisteredUsersPage()),
    );
  }

  void _logOut() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Users'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_bookings[index]['name'] ?? 'No name'),
            subtitle: Text(_bookings[index]['package'] ?? 'No package'),
            trailing: Text(_bookings[index]['date'] ?? 'No date'),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _viewRegisteredUsers,
              child: const Text('Registered Users'),
            ),
            ElevatedButton(
              onPressed: null,
              child: Text('View Booking Users'), // no action needed here
            ),
            ElevatedButton(
              onPressed: _logOut,
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
