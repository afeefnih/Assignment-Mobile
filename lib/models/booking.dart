class Booking {
  int id;
  DateTime bookdate;
  DateTime checkindate;
  DateTime checkoutdate;
  String homestypackage;
  int numguest;
  double packageprice;

  Booking(
      {required this.id,
      required this.bookdate,
      required this.checkindate,
      required this.checkoutdate,
      required this.homestypackage,
      required this.numguest,
      required this.packageprice});
}
