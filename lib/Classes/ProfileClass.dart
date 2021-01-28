class Profile{
  final String name;
  final String dob;
  final int ethnicity;
  final String account;
  final int gender;

  Profile({this.name, this.dob,this.gender,this.ethnicity,this.account});

  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'name': name,
      'dob': dob,
      'ethnicity': ethnicity,
      'account': account

    };
  }

  int getGender(){return gender;}

  String getName(){return name;}

  String getDOB(){return dob;}

  int getEthnicity(){return ethnicity;}

  String getAccount(){return account;}
}