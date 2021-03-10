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

  double _creatine;
  Account _account;
  int _fontShift = 0;
  TextStyle _appBarStyle;
  TextStyle _basicText;
  Color _newBlue ;
  Color _darkBlueAccent ;
  Color _appBarBack;
  Color _iconColor;

  void setStyles() async{
    String email = Provider.of<ContextInfo>(context, listen: false).getCurrentAccount().getEmail();
    int f = await DataAccess.instance.getFontSize(email);
    int p = await DataAccess.instance.getPalette(email);
    Color color1 = newBlue;
    Color color2 = darkBlueAccent;
    Color aBBack = newBlue;
    Color aColor = backBlue;

    if(p == 1){
      color1 = Colors.black;
      color2 = Colors.black;
      aBBack = Colors.white;
      aColor = color1;
    }

    setState(() {
      _appBarBack = aBBack;
      _fontShift = f;
      _appBarStyle = appBarStyle.copyWith(fontSize: 18 + f.toDouble(),color: aColor);
      _basicText = basicText.copyWith(fontSize: 18 + f.toDouble());
      _newBlue = color1;
      _darkBlueAccent = color2;
      _iconColor = aColor;
    });
  }

  @override
  void initState() {
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
        children: [Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Creatine: ",style: _basicText,),
            SizedBox(height: 5,),
            TextField(
              keyboardType: TextInputType.number,
              decoration: inputDecoration,
              style: _basicText,
              onChanged: (value){
                _creatine = double.parse(value);
              },
            ),
            SizedBox(height: 5,),
            Text(_getUnit(),style: _basicText,),
            SizedBox(height: 5,),
            ElevatedButton(onPressed: _showPopUp,style: elevatedButtonStyle.copyWith(backgroundColor: MaterialStateProperty.all<Color>(_newBlue)), child: Text("Info about EGFR",style: _basicText,)),
            ElevatedButton(
                onPressed: (){
                  if(_creatine != -1){
                    _calculate();
                  }
                },
                child: Text("Calculate",style: _basicText,),
              style: elevatedButtonStyle.copyWith(backgroundColor: MaterialStateProperty.all<Color>(_newBlue)),
            )
          ],
        )],
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
    Profile profile = Provider.of<ContextInfo>(context, listen: false).getCurrentProfile();

    double c;
    if(_account.getUnit() == 2){
      c = _convertCreatine(_creatine);
    }else{
      c = _creatine;
    }

    DateTime dob = DateTime.parse(profile.getDOB());
    Duration dif = DateTime.now().difference(dob);
    int age = (dif.inDays / 365).truncate();
    if(dif.inDays < 365){
      age = 1;
    }
    double egfr = 186 * pow((c / 88.4),-1.154) * pow(age,-0.203);
    if(profile.getGender() == 1){
      egfr = egfr *0.742;
    }
    if(profile.getEthnicity() == 1){
      egfr = egfr * 1.21;
    }

    Calculation calculation = new Calculation(
        date: DateTime.now().toString(),
        egfr: egfr,
      account: Provider.of<ContextInfo>(context, listen: false).getCurrentAccount().getEmail(),
      profile: profile.getName()
    );


    Provider.of<ContextInfo>(context, listen: false).setCurrentCalculation(calculation);
    Navigator.pop(context);
    Navigator.push(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => ViewCalculationPage()),
    );
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
            new ElevatedButton(
              style: elevatedButtonStyle.copyWith(backgroundColor: MaterialStateProperty.all<Color>(_newBlue)),
              child: new Text("Close",style: _basicText,),
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