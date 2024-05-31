import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'booking_page_2.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homestay Booking',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set up constants for repeated values
    final textStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    final buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.brown),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Homestay Booking System'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset('assets/icon.jpg'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Display the title of the app
              Text(
                'Homestay Booking System',
                style: textStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40), // Use the const keyword for widgets that don't change
              ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text('Register'),
              ),
              ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Login'),
              ),
              ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookingPage2()),
                  );
                },
                child: Text('View Packages'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
