class Booking {
  final DateTime bookdate;
  final DateTime checkindate;
  final DateTime checkoutdate;
  final String homestypackage;
  final int numguest;
  final double packageprice;

  Booking(
      {required this.bookdate,
      required this.checkindate,
      required this.checkoutdate,
      required this.homestypackage,
      required this.numguest,
      required this.packageprice});
}
