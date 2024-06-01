// profile_tab.dart
import 'package:flutter/material.dart';
import '/views/profile_update.dart';
import '../db/database_helper.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key, required this.id});
  final int id;

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      _userInfo = await dbHelper.getUserById(widget.id);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user info: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
        child: _userInfo != null
            ? SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person),
                                SizedBox(width: 8),
                                Text('Name: ${_userInfo!['name']}'),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.email),
                                SizedBox(width: 8),
                                Text('Email: ${_userInfo!['email']}'),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.phone),
                                SizedBox(width: 8),
                                Text('Phone: ${_userInfo!['phone']}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(id: widget.id),
                          ),
                        ).then((_) {
                          _fetchUserInfo();
                        });
                      },
                      child: const Text('Update Profile'),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        // Add logout functionality
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 88, 57, 45),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
            )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
