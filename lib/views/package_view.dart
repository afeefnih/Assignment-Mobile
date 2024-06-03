import 'package:assignment1/user/booking_form.dart';
import '../db/database_helper.dart';
import '../models/homestay.dart';
import 'login.dart';
import 'package:flutter/material.dart';

class PackageView extends StatelessWidget {
  const PackageView({super.key, this.id});
  final int? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homestay Package'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: PackageContent(
        id: id,
      ),
    );
  }
}

class PackageContent extends StatefulWidget {
  final int? id;
  const PackageContent({Key? key, this.id}) : super(key: key);

  @override
  State<PackageContent> createState() => _PackageContentState();
}

class _PackageContentState extends State<PackageContent> {
  List<double> _averageRatings = [];

  @override
  void initState() {
    super.initState();
    _loadRating();
  }

  void _loadRating() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<String> homestayLabel =
        Homestay.samples.map((homestay) => homestay.label).toList();

    List<double> averageRatings =
        await db.getAverageRatingsForHomestays(homestayLabel);
    setState(() {
      _averageRatings = averageRatings;
    });
  }

  double rating(int n) {
    double h;
    if (_averageRatings.isNotEmpty && n < _averageRatings.length) {
      h = _averageRatings[n];
    } else {
      h = 0.0;
    }
    return h;
  }

  Future<String> fetchUserName() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    Map<String, dynamic>? user = await dbHelper.getUserById(widget.id!);

    if (user != null && user.containsKey('name')) {
      return user['name'];
    } else {
      return 'User not found';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                (widget.id != null)
                    ? Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<String>(
                                  future: fetchUserName(),
                                  builder: (context, snapshot) {
                                    final userName = snapshot.data ?? 'User';
                                    return Text(
                                      'Welcome, $userName!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    );
                                  },
                                ),
                                Text('Your home away from home awaits you.'),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: Homestay.samples.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _showPackageDetails(
                          context,
                          Homestay.samples[index],
                        );
                      },
                      child: buildHomestayCard(
                          Homestay.samples[index], rating(index)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHomestayCard(Homestay homestay, double rating) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(homestay.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 13, 18, 15),
            child: Row(
              children: [
                Text(
                  homestay.label,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 255, 157, 0),
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPackageDetails(BuildContext context, Homestay homestay) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(homestay.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  homestay.label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Text(homestay.detail),
              Text("Based price: RM ${homestay.price.toStringAsFixed(2)}/day"),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (widget.id != null) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingForm(
                        id: widget.id!,
                        homestay: homestay,
                      ),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              },
              child: const Text('Choose'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
