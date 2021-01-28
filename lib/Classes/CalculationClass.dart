class Calculation{
  final String date;
  final double egfr;
  final String account;
  final String profile;

  Calculation({this.date,this.egfr,this.account,this.profile});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'egfr': egfr,
      'account': account,
      'profile': profile
    };
  }

  String getDate(){return date;}
  double getEgfr(){return egfr;}
  String getAccount(){return account;}
  String getProfile(){return profile;}
}