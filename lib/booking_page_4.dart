import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';




class BookingPage4 extends StatefulWidget {
  const BookingPage4({super.key});

  @override
  _BookingPage4State createState() => _BookingPage4State();
}

class _BookingPage4State extends State<BookingPage4> {
  final _controller = TextEditingController();
  double _rating = 0;
  List<Map<String, dynamic>> reviews = [];

  void _submitReview() {
    if (_controller.text.isNotEmpty && _rating > 0) {
      setState(() {
        reviews.add({
          'rating': _rating,
          'text': _controller.text,
        });
        _controller.clear();
        _rating = 0; // Reset rating after submission
      });

      // Show a thank you dialog box with a fun animation
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Thank You!'),
            content: const Text('Your review has been submitted.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Show a snackbar with a friendly message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide both rating and review text.'),
        ),
      );
    }
  }

  void _showConfettiAnimation() {
    // Use a confetti package (e.g., confetti_flutter) to create a celebratory effect
    // Implement confetti animation logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating'),
      ),
      body: Container(
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
                  color: Colors.white, //assign either here or to the container
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Give Ratings:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      RatingBar.builder(
                        initialRating: _rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          size: 25,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Give Reviews:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Write your review here',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _submitReview,
                        child: const Text('Submit Review'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'All Reviews:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              reviews.isEmpty
                  ? const Text('No reviews yet.')
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(reviews[index]['text']),
                          subtitle: Text('${reviews[index]['rating']} Stars'),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
