import 'package:egfr_calculator/Classes/CalculationClass.dart';
import 'package:egfr_calculator/DataAccess.dart';
import 'package:egfr_calculator/Screens/ViewProfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egfr_calculator/Context.dart';

import '../Colors.dart';

class ViewCalculationPage extends StatefulWidget{
  @override
  _ViewCalculationPageState createState() => _ViewCalculationPageState();
}

class _ViewCalculationPageState extends State<ViewCalculationPage> {

  Calculation _calculation;
  String _stage;

  @override
  void initState() {
    _calculation = Provider.of<ContextInfo>(context, listen: false).getCurrentCalculation();
    double egfr = _calculation.getEgfr();
    if(egfr >= 90){
      _stage = "1";
    }
    else if(egfr < 90 && egfr >= 60){
      _stage = "2";
    }
    else if(egfr < 60 && egfr >= 45){
      _stage = "3A";
    }
    else if(egfr < 45 && egfr >= 30){
      _stage = "3B";
    }
    else if(egfr < 30 && egfr >= 15){
      _stage = "4";
    }
    else{
      _stage = "5";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: newBlue,
        title: Text("Calculation Results",style: appBarStyle,),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: darkBlueAccent),
              borderRadius: BorderRadius.all(
                  Radius.circular(10.0) //
              ),
            ),
            child: Column(
              children: [
                Text("Stage "+_stage, style: basicText,),
                SizedBox(height: 5),
                Text("eGFR: "+ _calculation.getEgfr().toString()),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                          DataAccess.instance.insertCalculation(_calculation);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            PageRouteBuilder(pageBuilder: (_, __, ___) => ViewProfilePage()),
                          );
                        },
                        child: Text("Save",style: basicText,),
                      style: elevatedButtonStyle,
                    ),
                    ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            PageRouteBuilder(pageBuilder: (_, __, ___) => ViewProfilePage()),
                          );
                        },
                        style: elevatedButtonStyle,
                        child: Text("Discard")
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}