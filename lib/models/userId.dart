class UserId {
  String name;
  String email;
  String phone;
  String password;

  UserId({required this.name, required this.email, required this.phone, required this.password});

  void updateProfile({required String name, required String email, required String phone, required String password}) {
    this.name = name;
    this.email = email;
    this.phone = phone;
    this.password = password;
  }
}
