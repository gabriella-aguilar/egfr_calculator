class Account {
  final String email;
  final String password;
  final int unit;

  Account({this.email, this.password, this.unit});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'unit': unit
    };
  }

  String getEmail(){return email;}
  int getUnit(){return unit;}
  String getPassword(){return password;}
}