import '../main.dart';
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'BookingUsersPage.dart';
import 'EditUserPage.dart';

class RegisteredUsersPage extends StatefulWidget {
  @override
  _RegisteredUsersPageState createState() => _RegisteredUsersPageState();
}

class _RegisteredUsersPageState extends State<RegisteredUsersPage> {
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<Map<String, dynamic>> users = await db.getUsers();
    setState(() {
      _users = users;
    });
  }

  void _viewBookingUsers() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookingUsersPage()),
    );
  }

  void _logOut() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  void _editUser(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserPage(
          user: _users[index],
        ),
      ),
    );

    if (result != null && result == 'updated') {
      _loadUsers();
    }
  }

  void _deleteUser(int index) async {
    DatabaseHelper db = DatabaseHelper.instance;
    await db.deleteUser(_users[index]['userid']);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Users'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_users[index]['name'] ?? 'No name'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User ID: ${_users[index]['userid'].toString()}'),
                Text('Email: ${_users[index]['email']}'),
                Text('Phone: ${_users[index]['phone']}'),
                Text('Username: ${_users[index]['username']}'),
                Text('Password: ${_users[index]['password']}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editUser(index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteUser(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Registered Users'),
              onPressed: null, // no action needed here
            ),
            ElevatedButton(
              child: Text('View Booking Users'),
              onPressed: _viewBookingUsers,
            ),
            ElevatedButton(
              child: Text('Log Out'),
              onPressed: _logOut,
            ),
          ],
        ),
      ),
    );
  }
}
