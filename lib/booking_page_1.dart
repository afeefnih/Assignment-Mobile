import 'user.dart';
import 'package:flutter/material.dart';
import 'booking_page_2.dart'; // Import BookingPage2
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'main.dart';

class BookingPage1 extends StatefulWidget {
  @override
  _BookingPage1State createState() => _BookingPage1State();
}

class _BookingPage1State extends State<BookingPage1> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bookingDateTimeController = TextEditingController();
  final TextEditingController _checkInDateTimeController = TextEditingController();
  final TextEditingController _checkOutDateTimeController = TextEditingController();

  final List<int> _numGuestsList = List.generate(10, (index) => index + 1);
  int _numGuests = 1;
  DateTime? _selectedBookingDate;
  DateTime? _selectedCheckInDate;
  DateTime? _selectedCheckOutDate;
  int _selectedRequestIndex = -1;
  final List<String> _smoking = ['Smoking Room', 'Non-Smoking Room'];

  Future<void> _selectDate(BuildContext context, String fieldType) async {
    // Show date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate!= null) {
      // If date is selected, show time picker
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime!= null) {
        // If time is also selected, update the date and time accordingly
        setState(() {
          if (fieldType == 'booking') {
            // Update booking date and time
            _selectedBookingDate = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            _bookingDateTimeController.text =
                DateFormat('yyyy-MM-dd hh:mm a').format(_selectedBookingDate!);
          } else if (fieldType == 'checkin') {
            // Update check-in date and time
            _selectedCheckInDate = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            _checkInDateTimeController.text =
                DateFormat('yyyy-MM-dd hh:mm a').format(_selectedCheckInDate!);
          } else if (fieldType == 'checkout') {
            // Update check-out date and time
            _selectedCheckOutDate = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            _checkOutDateTimeController.text =
                DateFormat('yyyy-MM-dd hh:mm a').format(_selectedCheckOutDate!);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'User Details:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone No'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // Validate phone number format (10 digits)
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Validate email format
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Booking Information:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _bookingDateTimeController,
                  decoration: InputDecoration(
                    labelText: 'Booking Date and Time',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, 'booking'),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select booking date and time';
                    }
                    return null;
                  },
                  readOnly: true,
                ),
                TextFormField(
                  controller: _checkInDateTimeController,
                  decoration: InputDecoration(
                    labelText: 'Check-in Date',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, 'checkin'),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select check-in date';
                    }
                    return null;
                  },
                  readOnly: true,
                ),
                TextFormField(
                  controller: _checkOutDateTimeController,
                  decoration: InputDecoration(
                    labelText: 'Check-out Date',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, 'checkout'),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select check-out date';
                    }
                    return null;
                  },
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Additional Details:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _smoking
                      .asMap()
                      .entries
                      .map(
                        (MapEntry<int, String> entry) => RadioListTile<int>(
                          title: Text(entry.value),
                          value: entry.key,
                          groupValue: _selectedRequestIndex,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedRequestIndex = value ?? -1;
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  value: _numGuests,
                  items: _numGuestsList.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      _numGuests = value ?? 1;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Number of Guests',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.brown),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                    ),
                    onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Calculate the number of days
                      int numberOfDays = calculateNumberOfDays(
                          _selectedCheckInDate!, _selectedCheckOutDate!);

                      // Extract user information
                      String userInfo = 'User Information:\n';
                      userInfo += 'Name: ${_nameController.text}\n';
                      userInfo += 'Address: ${_addressController.text}\n';
                      userInfo += 'Phone No: ${_phoneController.text}\n';
                      userInfo += 'Email: ${_emailController.text}\n';
                      userInfo += 'No of Days: $numberOfDays\n';

                      // Additional Requests
                      String additionalRequest = _selectedRequestIndex != -1
                          ? 'Additional Details: ${_smoking[_selectedRequestIndex]}\n'
                          : '';

                      // Display user information and additional requests
                                                showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Booking Summary'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(userInfo),
                                      const SizedBox(height: 10),
                                      Text(additionalRequest),
                                      const SizedBox(height: 10),
                                      Text('Number of Guests: $_numGuests'),
                                    ],
                                  ),
                                  actions: [
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.brown; // Color when button is pressed
                                  }
                                  return Colors.white; // Default color
                                }),
                                foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.white; // Text color when button is pressed
                                  }
                                  return Colors.brown; // Default text color
                                }),
                                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingPage2(
                                      // Data as arguments to send to next page.
                                      user: User(numberOfDays, _numGuests),
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Next'),
                            ),
                          ],
                        );
                      },
                    );

                    }
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Add this method to calculate the number of days
  int calculateNumberOfDays(DateTime checkIn, DateTime checkOut) {
    return checkOut.difference(checkIn).inDays;
  }
}


