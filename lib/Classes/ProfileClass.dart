class Profile{
  final String name;
  final String dob;
  final int ethnicity;
  final String account;

  Profile({this.name, this.dob,this.ethnicity,this.account});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dob': dob,
      'ethnicity': ethnicity,
      'account': account

    };
  }

  String getName(){return name;}

  String getDOB(){return dob;}

  int getEthnicity(){return ethnicity;}

  String getAccount(){return account;}
}