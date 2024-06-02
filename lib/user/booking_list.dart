import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../db/database_helper.dart';
import 'package:flutter/material.dart';
import 'booking_update.dart';

class BookingTab extends StatefulWidget {
  final int id;

  const BookingTab({super.key, required this.id});
  @override
  _BookingTabState createState() => _BookingTabState();
}

class _BookingTabState extends State<BookingTab> {
  List<Map<String, dynamic>> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<Map<String, dynamic>> bookings = await db.getBookingsForUser(
        widget.id); // Replace userId with the specific user ID
    setState(() {
      _bookings = bookings;
    });
  }

  void _editBooking(int index) {
    // Navigate to the EditBookingPage for editing the booking details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingUpdatePage(
          id: widget.id,
          bookingDetails: _bookings[index],
        ),
      ),
    ).then((value) => _loadBookings());
  }

  void _deleteBooking(int index) async {
    // Create a mutable copy of the bookings list
    List<Map<String, dynamic>> mutableBookings = List.from(_bookings);

    // Get the booking ID to be deleted
    int bookingId = _bookings[index]['bookid'];

    // Delete the booking from the database
    DatabaseHelper db = DatabaseHelper.instance;
    int deletedRows = await db.deleteBooking(bookingId);

    if (deletedRows > 0) {
      // Show snackbar with a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      // Remove the booking from the mutable list
      mutableBookings.removeAt(index);

      // Update the state with the modified list
      setState(() {
        _bookings = mutableBookings;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking List'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: _bookings.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.home),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              _bookings[index]['homestypackage'] ?? 'No package',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.visible,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today),
                              SizedBox(width: 8),
                              Text(_bookings[index]['bookdate'] ?? 'No date'),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editBooking(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteBooking(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
