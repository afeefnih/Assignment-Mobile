import 'package:flutter/material.dart';
import '../db/database_helper.dart';
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF8BC34A),
              Color(0xFFCDDC39),
            ],
            stops: [0.1, 0.5, 0.9],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(_users[index]['name'] ?? 'No name'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              children: [
                                Icon(Icons.person),
                                SizedBox(width: 8),
                                Text('User ID: ${_users[index]['userid'].toString()}'),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.email),
                                SizedBox(width: 8),
                                Text('Email: ${_users[index]['email']}'),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.phone),
                                SizedBox(width: 8),
                                Text('Phone: ${_users[index]['phone']}'),
                              ],
                            ),
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
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
