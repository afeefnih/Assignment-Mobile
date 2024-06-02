import 'BookingUsersPage.dart';
import '../main.dart';
import '../db/database_helper.dart';
import 'package:flutter/material.dart';
import 'RegisteredUserPage.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  _loadUsers() async {
    DatabaseHelper dbhelper = DatabaseHelper.instance;
    final users = await dbhelper.getUsers();
    setState(() {
      _users = users
          .where((user) => user['name'] != null && user['package'] != null)
          .toList();
    });
  }

  _deleteUser(int id) async {
    DatabaseHelper dbhelper = DatabaseHelper.instance;
    await dbhelper.deleteUser(id);
    _loadUsers();
  }

  _updateUser(int id, String name, String email, String phone, String username,
      String password) async {
    DatabaseHelper dbhelper = DatabaseHelper.instance;
    //await dbhelper.updateUser(id, name, email, phone, username, password);
    await dbhelper.updateUser(id, {
      'name': name,
      'email': email,
      'phone': int.parse(phone),
      'password': password,
    });

    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Admin Page'),
        ),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_users[index]['name'] ?? 'No name'),
            subtitle: Text(_users[index]['package'] ?? 'No package'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to update user page
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteUser(_users[index]['id']);
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              child: Text('View Registered Users'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisteredUsersPage()),
                );
              },
            ),
            ElevatedButton(
              child: Text('View Booking Users'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingUsersPage()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Log Out'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
