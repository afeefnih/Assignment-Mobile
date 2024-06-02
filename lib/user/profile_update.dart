import '../db/database_helper.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final int id;

  const ProfilePage({super.key, required this.id});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserInfo() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    Map<String, dynamic>? user = await dbHelper.getUserById(widget.id);
    setState(() {
      if (user != null) {
        _nameController.text = user['name'] ?? '';
        _emailController.text = user['email'] ?? '';
        _phoneController.text = user['phone'].toString();
        _usernameController.text = user['username'] ?? '';
        _passwordController.text = user['password'].toString();
      }
    });
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      try {
        await dbHelper.updateUser(widget.id, {
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': int.parse(_phoneController.text),
          'username': _usernameController.text,
          'password': _passwordController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
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
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 10),
                const Text('Name'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person), hintText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text('Email'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email), hintText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Add additional email validation if needed
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text('Phone'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone), hintText: 'Phone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // Add additional phone validation if needed
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                const Text('Username'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person), hintText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text('Password'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock), hintText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    // Add additional password validation if needed
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateProfile,
                  child: const Text('Update Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
