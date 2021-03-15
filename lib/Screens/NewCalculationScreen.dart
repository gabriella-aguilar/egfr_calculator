import 'dart:math';
import 'package:egfr_calculator/Classes/CalculationClass.dart';
import 'package:egfr_calculator/Classes/ProfileClass.dart';
import 'package:egfr_calculator/Classes/AccountsClass.dart';
import 'package:egfr_calculator/Context.dart';
import 'package:egfr_calculator/DataAccess.dart';
import 'package:egfr_calculator/Screens/ViewCalculation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../Colors.dart';
import 'ViewProfile.dart';

class NewCalculationPage extends StatefulWidget{
  @override
  _NewCalculationPageState createState() => _NewCalculationPageState();
}

class _NewCalculationPageState extends State<NewCalculationPage> {
  bool _error;
  double _creatine;
  Account _account;
  int _fontShift = 0;
  TextStyle _appBarStyle;
  TextStyle _basicText;
  TextStyle _errorText;
  Color _newBlue ;
  Color _darkBlueAccent ;
  Color _appBarBack;
  Color _iconColor;
  Color _newBlue2;

  void setStyles() async{
    String email = Provider.of<ContextInfo>(context, listen: false).getCurrentAccount().getEmail();
    int f = await DataAccess.instance.getFontSize(email);
    int p = await DataAccess.instance.getPalette(email);
    Color color1 = newBlue;
    Color color2 = darkBlueAccent;
    Color aBBack = newBlue;
    Color aColor = backBlue;
    Color color3 = newBlue2;
    TextStyle e = errorTextStyle.copyWith(fontSize: 18 + f.toDouble());
    if(p == 1){
      color1 = Colors.black;
      color2 = Colors.black;
      aBBack = Colors.white;
      color3 = Colors.white;
      aColor = color1;
      e = errorTextStyle.copyWith(fontSize: 20 + f.toDouble(),color: color1);
    }

    setState(() {
      _appBarBack = aBBack;
      _fontShift = f;
      _appBarStyle = appBarStyle.copyWith(fontSize: 18 + f.toDouble(),color: aColor);
      _basicText = basicText.copyWith(fontSize: 18 + f.toDouble());
      _newBlue = color1;
      _darkBlueAccent = color2;
      _iconColor = aColor;
      _newBlue2 = color3;
      _errorText = e;
    });
  }

  @override
  void initState() {
    _error = false;
    _creatine = -1;
    _account = Provider.of<ContextInfo>(context,listen: false).getCurrentAccount();
    setStyles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_newBlue == null){
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: _iconColor,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => ViewProfilePage()),
                );
              },
            );
            //return Container();
          },
        ),
        backgroundColor: _appBarBack,
        title: Text("New Calculation",style: _appBarStyle,),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        children: [Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          decoration: BoxDecoration(
            color: _newBlue2,
            border: Border.all(color: darkBlueAccent),
            borderRadius: BorderRadius.all(
                Radius.circular(30.0) //
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_error ? "Please enter a valid input" : "",style: _errorText,),
              Container(
                decoration: BoxDecoration(
                  color: backBlue,
                  borderRadius: BorderRadius.all(
                      Radius.circular(30.0) //
                  ),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: inputDecoration.copyWith(hintText: ("Creatine in "+_getUnit())),
                  style: _basicText,
                  onChanged: (value){
                    _creatine = double.tryParse(value);
                  },
                ),
              ),

              SizedBox(height: 5,),

              RaisedButton(
                onPressed: (){
                  if(_creatine != -1){
                    _calculate();
                  }
                },
                child: Text("Calculate",style: _basicText.copyWith(color: backBlue),),
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                color: _newBlue,
              )
            ],
          ),
        ),
        SizedBox(height: 15),
        RaisedButton(
            onPressed: _showPopUp,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            color: _newBlue,
            child: Text("Info about EGFR",style: _basicText.copyWith(color: backBlue),)
        ),]
      ),
    );
  }



  String _getUnit(){
    if(_account.getUnit() == 1){
      return "mmol/L";
    }
    return "mg/dL";
  }

  double _convertCreatine(double start){
    return (start / 18);
  }

  _calculate(){
    if(_creatine != null && _creatine > 0){

      Profile profile =
      Provider.of<ContextInfo>(context, listen: false).getCurrentProfile();

      double c;

      if (_account.getUnit() == 2) {
        c = _convertCreatine(_creatine);
      } else {
        c = _creatine;
      }

      DateTime dob = DateTime.parse(profile.getDOB());
      Duration dif = DateTime.now().difference(dob);
      int age = (dif.inDays / 365).truncate();
      if (dif.inDays < 365) {
        age = 1;
      }
      double egfr = 186 * pow((c / 88.4), -1.154) * pow(age, -0.203);
      if (profile.getGender() == 1) {
        egfr = egfr * 0.742;
      }
      if (profile.getEthnicity() == 1) {
        egfr = egfr * 1.21;
      }

      Calculation calculation = new Calculation(
          date: DateTime.now().toString(),
          egfr: egfr,
          account: Provider.of<ContextInfo>(context, listen: false)
              .getCurrentAccount()
              .getEmail(),
          profile: profile.getName());

      Provider.of<ContextInfo>(context, listen: false)
          .setCurrentCalculation(calculation);

      Navigator.pop(context);
      Navigator.push(
        context,
        PageRouteBuilder(pageBuilder: (_, __, ___) => ViewCalculationPage()),
      );
    }else{
      setState(() {
        _error = true;
      });
    }
  }

  void _showPopUp() {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String body = "cvbhnmfghbjkcvbnm, dfhjbnkmlbfhcjndkmslbjdfnkm hnjfkdlmshbfjvdnkshbjvfndskbhjfndk hfjndkshbfjdnskhbvjdcnkmbhvjfdn";
        return AlertDialog(
          title: new Text("Here's Some Info About EGFR Calculations:",style: _basicText,),
          content: new Text(body,style: _basicText,),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new RaisedButton(
              color: newBlue,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              child: new Text("Close",style: _basicText.copyWith(color:backBlue),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}