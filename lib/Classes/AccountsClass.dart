class Account {
  final String email;
  final String password;

  Account({this.email, this.password});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,

    };
  }

  String getEmail(){return email;}

  String getPassword(){return password;}
}