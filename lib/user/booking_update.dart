import '../db/database_helper.dart';
import '../models/booking.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/homestay.dart';

class BookingUpdatePage extends StatefulWidget {
  final int id;
  final Map<String, dynamic> bookingDetails;

  const BookingUpdatePage(
      {Key? key, required this.id, required this.bookingDetails})
      : super(key: key);

  @override
  _BookingUpdatePageState createState() => _BookingUpdatePageState();
}

class _BookingUpdatePageState extends State<BookingUpdatePage> {
  late Booking _booking;
  late TextEditingController _bookingDateController;
  late TextEditingController _checkInDateController;
  late TextEditingController _checkOutDateController;
  late TextEditingController _numGuestController;
  Homestay? _selectedHomestay;
  late double price;

  void updatePackagePrice() {
    _booking.packageprice = calculateTotal(
        price,
        calculateNumberOfDays(_booking.checkindate, _booking.checkoutdate),
        _booking.numguest);
  }

  Future<void> _updateBooking() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;

    await dbHelper.updateBooking(
      _booking.id,
      _booking.bookdate,
      _booking.checkindate,
      _booking.checkoutdate,
      _booking.homestypackage,
      _booking.numguest,
      _booking.packageprice,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking updated successfully'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    DateFormat timeFormat = DateFormat('HH:mm:ss');

    DateTime datePart = dateFormat.parse(widget.bookingDetails['bookdate']);
    DateTime timePart = timeFormat.parse(widget.bookingDetails['booktime']);

    DateTime bookDateTime = DateTime(
      datePart.year,
      datePart.month,
      datePart.day,
      timePart.hour,
      timePart.minute,
      timePart.second,
    );

    _booking = Booking(
      id: widget.bookingDetails['bookid'],
      bookdate: bookDateTime,
      checkindate: DateTime.parse(widget.bookingDetails['checkindate']),
      checkoutdate: DateTime.parse(widget.bookingDetails['checkoutdate']),
      homestypackage: widget.bookingDetails['homestypackage'],
      numguest: widget.bookingDetails['numguest'],
      packageprice: widget.bookingDetails['packageprice'],
    );

    _bookingDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd hh:mm a')
            .format(_booking.bookdate)
            .toString());
    _checkInDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(_booking.checkindate).toString());
    _checkOutDateController = TextEditingController(
        text:
            DateFormat('yyyy-MM-dd').format(_booking.checkoutdate).toString());

    _numGuestController =
        TextEditingController(text: _booking.numguest.toString());

    _selectedHomestay = Homestay.samples.firstWhere(
      (homestay) => homestay.label == _booking.homestypackage,
      orElse: () => Homestay.samples[0],
    );

    price = _selectedHomestay!.price;
  }

  @override
  void dispose() {
    _bookingDateController.dispose();
    _checkInDateController.dispose();
    _checkOutDateController.dispose();
    _numGuestController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, String fieldType, String content) async {
    DateTime initDateTime;

    DateFormat dateTimeFormat = DateFormat('yyyy-MM-dd hh:mm a');

    if (content.isEmpty) {
      initDateTime = DateTime.now();
    } else if (fieldType == 'booking') {
      initDateTime = dateTimeFormat.parse(content);
    } else {
      initDateTime = DateTime.parse(content);
    }

    // Show date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      if (fieldType == 'booking') {
        // If date is selected, show time picker
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime:
              TimeOfDay(hour: initDateTime.hour, minute: initDateTime.minute),
        );
        if (pickedTime != null) {
          setState(() {
            // Update booking date and time
            DateTime selectedBookingDate = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            _bookingDateController.text =
                DateFormat('yyyy-MM-dd hh:mm a').format(selectedBookingDate);
            _booking.bookdate = selectedBookingDate;
          });
        }
      } else if (fieldType == 'checkin') {
        setState(() {
          // Update check-in date and time
          DateTime selectedCheckInDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
          );
          _checkInDateController.text =
              DateFormat('yyyy-MM-dd').format(selectedCheckInDate);
          _booking.checkindate = selectedCheckInDate;
          updatePackagePrice();
        });
      } else if (fieldType == 'checkout') {
        setState(() {
          // Update check-out date and time
          DateTime selectedCheckOutDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
          );
          _checkOutDateController.text =
              DateFormat('yyyy-MM-dd').format(selectedCheckOutDate);
          _booking.checkoutdate = selectedCheckOutDate;
          updatePackagePrice();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Booking'),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text('Booking Date and Time'),
              const SizedBox(height: 10),
              TextFormField(
                controller: _bookingDateController,
                decoration: InputDecoration(
                  hintText: 'Pick Date and Time',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(
                        context, 'booking', _bookingDateController.text),
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              const Text('Check-in Date'),
              const SizedBox(height: 10),
              TextFormField(
                controller: _checkInDateController,
                decoration: InputDecoration(
                  hintText: 'Pick Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(
                        context, 'checkin', _checkInDateController.text),
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              const Text('Check-out Date'),
              const SizedBox(height: 10),
              TextFormField(
                controller: _checkOutDateController,
                decoration: InputDecoration(
                  hintText: 'Pick Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(
                        context, 'checkout', _checkOutDateController.text),
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              const Text('Homestay Package'),
              const SizedBox(height: 10),
              DropdownButtonFormField<Homestay>(
                dropdownColor: Colors.white,
                value: _selectedHomestay,
                decoration: const InputDecoration(
                  hintText: 'Homestay Package',
                  prefixIcon: Icon(Icons.home),
                ),
                items: Homestay.samples.map((homestay) {
                  return DropdownMenuItem<Homestay>(
                    value: homestay,
                    child: Text(homestay.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedHomestay = value;
                    _booking.homestypackage = value!.label;
                    price = value.price;
                    updatePackagePrice();
                  });
                },
              ),
              const SizedBox(height: 10),
              const Text('Number of Guests'),
              const SizedBox(height: 10),
              TextFormField(
                controller: _numGuestController,
                decoration: InputDecoration(
                  hintText: 'Number of Guests',
                  prefixIcon: Icon(Icons.people), // Add icon here
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      _booking.numguest = int.parse(value);
                      updatePackagePrice();
                    }
                  });
                },
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 18, 20, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('RM ${_booking.packageprice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _updateBooking();
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateTotal(double base, int d, int g) {
    return (base + (g * 15)) * d;
  }

  int calculateNumberOfDays(DateTime checkIn, DateTime checkOut) {
    return checkOut.difference(checkIn).inDays;
  }
}
