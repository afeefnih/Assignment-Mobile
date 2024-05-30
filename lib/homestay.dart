class Homestay {
  String label;
  String imagePath;
  String detail;
  double price;
  int max;

  Homestay(this.label, this.imagePath, this.detail, this.price, this.max);

  static List<Homestay> samples = [
    Homestay('Taman Seri Impian', 'assets/image1.jpg','Type: Town House\nNumber of Guests: 5-6\nAdditional Packages: Mini Cinema, Pool',230,6),
    Homestay('Taman Desa Harmoni', 'assets/image2.jpg','Type: Town House\nNumber of Guests: 7-8\nAdditional Packages: BBQ Site, Snooker Table',250,8),
    Homestay('Impian Farm', 'assets/image3.jpg','Type: Farm House\nNumber of Guests: 6-7\nAdditional Packages: Karoake Set, Fruit Festival, Water Rafting',280,7),
    Homestay('Impian Camp Site', 'assets/image4.jpg','Type: Camping Site\nNumber of Guests: 2-3\nAdditional Packages: Breakfast, Fire Camp, Jungle Tracking',80,3),
    Homestay('Pantai House', 'assets/image5.jpg','Type: Beach House\nNumber of Guests: 3-4\nAdditional Packages: Lunch, Dinner, Snorkling, Hopping Island',120,4),
  ];
}
