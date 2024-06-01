import 'package:flutter/material.dart';
import 'views/welcome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    );
    return MaterialApp(
      title: 'Homestay Booking',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 39, 35, 45),
          background: const Color.fromARGB(255, 88, 57, 45),
        ),
        dialogBackgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBarTheme: const AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 88, 57, 45),
          foregroundColor: Color.fromARGB(255, 255, 255, 255),
          // Set the app bar color here
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 88, 57, 45),
              foregroundColor: Colors.white,
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 13)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          filled: true,
          iconColor: Colors.black,
          fillColor: Colors.white,
          border: outlineInputBorder,
        ),
      ),
      home: Welcome(),
    );
  }
}
