import 'package:assignment1/models/booking.dart';
import 'package:assignment1/models/homestay.dart';
import '../db/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'booking_detail.dart';

class BookingForm extends StatefulWidget {
  final int id;
  final Homestay homestay;
  const BookingForm({super.key, required this.id, required this.homestay});
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    Map<String, dynamic>? user = await dbHelper.getUserById(widget.id);
    setState(() {
      _user = user;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bookingDateTimeController =
      TextEditingController(
    text: DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),
  );
  final TextEditingController _checkInDateTimeController =
      TextEditingController();
  final TextEditingController _checkOutDateTimeController =
      TextEditingController();

  final List<int> _numGuestsList = List.generate(10, (index) => index + 1);
  int _numGuests = 1;
  DateTime? _selectedBookingDate = DateTime.now();
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

    if (pickedDate != null) {
      if (fieldType == 'booking') {
        // If date is selected, show time picker
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
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
          });
        }
      } else if (fieldType == 'checkin') {
        setState(() {
          // Update check-in date and time
          _selectedCheckInDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
          );
          _checkInDateTimeController.text =
              DateFormat('yyyy-MM-dd').format(_selectedCheckInDate!);
        });
      } else if (fieldType == 'checkout') {
        setState(() {
          // Update check-out date and time
          _selectedCheckOutDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
          );
          _checkOutDateTimeController.text =
              DateFormat('yyyy-MM-dd').format(_selectedCheckOutDate!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> userInfo = [];

    if (_user != null) {
      userInfo = [
        Row(
          children: [
            Icon(Icons.person),
            SizedBox(width: 8),
            Text('Name: ${_user!['name']}'),
          ],
        ),
        Row(
          children: [
            Icon(Icons.email),
            SizedBox(width: 8),
            Text('Email: ${_user!['email']}'),
          ],
        ),
        Row(
          children: [
            Icon(Icons.phone),
            SizedBox(width: 8),
            Text('Phone: ${_user!['phone']}'),
          ],
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Form'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: userInfo,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Booking Information:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text('Booking Date and Time'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _bookingDateTimeController,
                  decoration: InputDecoration(
                    hintText: 'Pick Date and Time',
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
                const SizedBox(height: 10),
                Text('Check-in Date'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _checkInDateTimeController,
                  decoration: InputDecoration(
                    hintText: 'Pick Date',
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
                const SizedBox(height: 10),
                Text('Check-out Date'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _checkOutDateTimeController,
                  decoration: InputDecoration(
                    hintText: 'Pick Date',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, 'checkout'),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select check-out date';
                    } else if (value ==
                        DateFormat('yyyy-MM-dd')
                            .format(_selectedCheckInDate!)) {
                      return 'Cant pick same as check-in';
                    }
                    return null;
                  },
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                Text('Number of Guests'),
                const SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  dropdownColor: Colors.white,
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
                        (MapEntry<int, String> entry) => SizedBox(
                          height: 30,
                          child: RadioListTile<int>(
                            title: Text(entry.value),
                            value: entry.key,
                            groupValue: _selectedRequestIndex,
                            onChanged: (int? value) {
                              setState(() {
                                _selectedRequestIndex = value ?? -1;
                              });
                            },
                            contentPadding: EdgeInsets.all(0),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
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
                                Column(
                                  children: userInfo,
                                ),
                                const SizedBox(height: 7),
                                Text(
                                    'Check In: ${DateFormat('yyyy-MM-dd').format(_selectedCheckInDate!)}'),
                                Text(
                                    'Check Out: ${DateFormat('yyyy-MM-dd').format(_selectedCheckOutDate!)}'),
                                Text('Number of Guests: $_numGuests'),
                                const SizedBox(height: 7),
                                Text(additionalRequest),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookingDetail(
                                        booking: Booking(
                                            bookdate: _selectedBookingDate!,
                                            checkindate: _selectedCheckInDate!,
                                            checkoutdate:
                                                _selectedCheckOutDate!,
                                            homestypackage:
                                                widget.homestay.label,
                                            numguest: _numGuests,
                                            packageprice: widget.homestay.price,
                                            id: widget.id),
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
}
