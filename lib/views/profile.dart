import 'package:flutter/material.dart';
import 'profile_update.dart';
import '../db/database_helper.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, required this.id});
  final int id;
  Future<String> fetchUserInfo() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    Map<String, dynamic>? user = await dbHelper.getUserById(id);

    if (user != null) {
      return user.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join('\n');
    } else {
      return 'User not found';
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
        decoration: BoxDecoration(
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
        child: Column(
          children: [
            FutureBuilder<String>(
              future: fetchUserInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Center(
                    child: Text(snapshot.data ?? 'No data'),
                  );
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(id: id),
                  ),
                );
              },
              child: const Text(
                'Update Profile',
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'LogOut',
                style: TextStyle(
                  fontSize: 18,
                  color: const Color.fromARGB(255, 88, 57, 45),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
