import '../models/booking.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';


class EditBookingPage extends StatefulWidget {
  final int id;
  final Map<String, dynamic> bookingDetails;

  const EditBookingPage({Key? key, required this.id, required this.bookingDetails})
      : super(key: key);

  @override
  _EditBookingPageState createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  late Booking _booking;
  late TextEditingController _bookingDateController;
  late TextEditingController _checkInDateController;
  late TextEditingController _checkOutDateController;
  late TextEditingController _homestayPackageController;
  late TextEditingController _numGuestController;

  @override
  void initState() {
    super.initState();
    _booking = Booking(
      id: widget.bookingDetails['bookid'],
      bookdate: DateTime.parse(widget.bookingDetails['bookdate']),
      checkindate: DateTime.parse(widget.bookingDetails['checkindate']),
      checkoutdate: DateTime.parse(widget.bookingDetails['checkoutdate']),
      homestypackage: widget.bookingDetails['homestypackage'],
      numguest: widget.bookingDetails['numguest'],
      packageprice: widget.bookingDetails['packageprice'],
    );

    _bookingDateController = TextEditingController(text: _booking.bookdate.toString());
    _checkInDateController = TextEditingController(text: _booking.checkindate.toString());
    _checkOutDateController = TextEditingController(text: _booking.checkoutdate.toString());
    _homestayPackageController = TextEditingController(text: _booking.homestypackage);
    _numGuestController = TextEditingController(text: _booking.numguest.toString());
  }

  @override
  void dispose() {
    _bookingDateController.dispose();
    _checkInDateController.dispose();
    _checkOutDateController.dispose();
    _homestayPackageController.dispose();
    _numGuestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Booking Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 60,
              child: TextFormField(
                controller: _bookingDateController,
                decoration: InputDecoration(
                  labelText: 'Booking Date',
                  prefixIcon: Icon(Icons.calendar_today), // Add icon here
                ),
                onChanged: (value) {
                  // Update the booking date
                  // For example: _booking.bookdate = DateTime.parse(value);
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 60,
              child: TextFormField(
                controller: _checkInDateController,
                decoration: InputDecoration(
                  labelText: 'Check-in Date',
                  prefixIcon: Icon(Icons.calendar_today), // Add icon here
                ),
                onChanged: (value) {
                  // Update the check-in date
                  // For example: _booking.checkindate = DateTime.parse(value);
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 60,
              child: TextFormField(
                controller: _checkOutDateController,
                decoration: InputDecoration(
                  labelText: 'Check-out Date',
                  prefixIcon: Icon(Icons.calendar_today), // Add icon here
                ),
                onChanged: (value) {
                  // Update the check-out date
                  // For example: _booking.checkoutdate = DateTime.parse(value);
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 60,
              child: TextFormField(
                controller: _homestayPackageController,
                decoration: InputDecoration(
                  labelText: 'Homestay Package',
                  prefixIcon: Icon(Icons.home), // Add icon here
                ),
                onChanged: (value) {
                  // Update the homestay package
                  // For example: _booking.homestypackage = value;
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 60,
              child: TextFormField(
                controller: _numGuestController,
                decoration: InputDecoration(
                  labelText: 'Number of Guests',
                  prefixIcon: Icon(Icons.people), // Add icon here
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  // Update the number of guests
                  // For example: _booking.numguest = int.parse(value);
                },
              ),
            ),
             SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit button press
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
