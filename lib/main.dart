import 'login_page.dart';
import 'register_page.dart';
import 'booking_page_2.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homestay Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Set background color to blue
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Homestay Booking System',
              style: TextStyle(
                fontSize: 32, // Adjust font size to your preference
                fontWeight: FontWeight.bold, // Apply bold style
                color: Colors.white, // Set text color to white
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40), // Add some space between the title and buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to BookingPage2 regardless of authentication status
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingPage2()),
                );
              },
              child: Text('View Packages'),
            )
          ],
        ),
      ),
    );
  }
}