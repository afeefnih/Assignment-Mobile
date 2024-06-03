import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../views/booking_update.dart';

class BookingUsersPage extends StatefulWidget {
  @override
  _BookingUsersPageState createState() => _BookingUsersPageState();
}

class _BookingUsersPageState extends State<BookingUsersPage> {
  List<Map<String, dynamic>> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _editBooking(int index) {
    // Navigate to the EditBookingPage for editing the booking details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingUpdatePage(
          bookingDetails: _bookings[index],
          isAdmin: true,
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

  void _loadBookings() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<Map<String, dynamic>> bookings = await db.getBookings();
    setState(() {
      _bookings = bookings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Users'),
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
                      title: Text(
                        _bookings[index]['name'].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 8),
                              Text(
                                  'User ID: ${_bookings[index]['userid'].toString()}'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.home),
                              SizedBox(width: 8),
                              Text(_bookings[index]['homestypackage'] ??
                                  'No package'),
                            ],
                          ),
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
