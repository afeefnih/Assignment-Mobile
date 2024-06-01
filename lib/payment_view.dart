import 'models/user.dart';
import 'booking_page_4.dart';
import 'package:flutter/material.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key, required this.user, required this.price});
  final double price;
  final User user;

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final TextEditingController _discountCodeController = TextEditingController();

  double _discountAmount = 0;
  late double _payment;

  @override
  void initState() {
    super.initState();
    _payment =
    
        calculateTotal(widget.price, widget.user.days, widget.user.guestsNum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
      ),
      body: Container(
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
                        decoration:
                            const InputDecoration(hintText: 'Enter code here', border: OutlineInputBorder()),
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
              Text(
                "Based Price: ${widget.price.toStringAsFixed(2)}/day\n"
                "No of Days: ${widget.user.days}\n"
                "No of Guests: ${widget.user.guestsNum}\n"
                "Total before discount: RM${_payment.toStringAsFixed(2)}\n"
                "Discount: RM${_discountAmount.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // Display total payment after discount
              Text(
                'Total Payment: RM${(_payment - _discountAmount).toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingPage4(),
                    ),
                  );
                },
                child: const Text('Proceed'),
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
