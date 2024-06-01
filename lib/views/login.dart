import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // Import sq
import 'register.dart'; // Import RegisterPage
import '../database/database_helper.dart';
import 'user_tab.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      Database db = await DatabaseHelper.instance.database;
      List<Map<String, dynamic>> result = await db.query(
        DatabaseHelper.tableUsers,
        where: 'username =? AND password =?',
        whereArgs: [_usernameController.text, _passwordController.text],
      );

      if (result.isNotEmpty) {
        if (!mounted) return; // Ensure the widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TabView(
                    id: result.first['userid'],
                  )), // Navigate to BookingPage1
        );
        
      } else {
        if (!mounted) return; // Ensure the widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset('assets/icon.jpg'),
          onPressed: () {
            Navigator.pop(context);
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
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person), labelText: 'Username'),
                  style: TextStyle(fontWeight: FontWeight.bold),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock), labelText: 'Password'),
                  obscureText: true,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text(
                    'Dont have account? Register Now',
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
        ),
      ),
    );
  }
}