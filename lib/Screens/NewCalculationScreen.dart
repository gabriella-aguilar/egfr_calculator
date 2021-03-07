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


  void setStyles() async{
    String email = Provider.of<ContextInfo>(context, listen: false).getCurrentAccount().getEmail();
    int f = await DataAccess.instance.getFontSize(email);
    setState(() {
      _fontShift = f;
      _appBarStyle = appBarStyle.copyWith(fontSize: 18 + f.toDouble());
      _basicText = basicText.copyWith(fontSize: 18 + f.toDouble());

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

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: backBlue,
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
        backgroundColor: newBlue,
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
            ElevatedButton(
                onPressed: (){
                  if(_creatine != -1){
                    _calculate();
                  }
                },
                child: Text("Calculate",style: _basicText,),
              style: elevatedButtonStyle,
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
}