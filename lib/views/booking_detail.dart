import 'package:intl/intl.dart';
import '../models/booking.dart';
import 'rating_add.dart';
import 'package:flutter/material.dart';

class BookingDetail extends StatefulWidget {
  const BookingDetail({super.key, required this.booking});
  final Booking booking;

  @override
  _BookingDetailState createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  final TextEditingController _discountCodeController = TextEditingController();

  double _discountAmount = 0;
  late double _payment;

  int calculateNumberOfDays(DateTime checkIn, DateTime checkOut) {
    return checkOut.difference(checkIn).inDays;
  }

  @override
  void initState() {
    super.initState();
    _payment = calculateTotal(
        widget.booking.packageprice,
        calculateNumberOfDays(
            widget.booking.checkindate, widget.booking.checkoutdate),
        widget.booking.numguest);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Discount Code:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: _discountCodeController,
                        decoration: const InputDecoration(
                            hintText: 'Enter code here',
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_discountCodeController.text == "15p") {
                                setState(() {
                                  _discountAmount = _payment * 0.15;
                                });
                              }
                            },
                            child: const Text('Apply'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Based Price: ${widget.booking.packageprice.toStringAsFixed(2)}/day\n"
                      "Check In: ${DateFormat('yyyy-MM-dd').format(widget.booking.checkindate)}\n"
                      "Check Out: ${DateFormat('yyyy-MM-dd').format(widget.booking.checkoutdate)}\n"
                      "No of Days: ${calculateNumberOfDays(widget.booking.checkindate, widget.booking.checkoutdate)}\n"
                      "No of Guests: ${widget.booking.numguest}\n"
                      "Total before discount: RM${_payment.toStringAsFixed(2)}\n"
                      "Discount: RM${_discountAmount.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    // Display total payment after discount
                    Text(
                      'Total Payment: RM${(_payment - _discountAmount).toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RatingAdd(),
                      ),
                    );
                  },
                  child: const Text('Confirm Booking'),
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
}
