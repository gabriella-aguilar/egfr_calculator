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
    _calculation = Provider.of<ContextInfo>(context, listen: false).getCurrentCalculation();
    double egfr = _calculation.getEgfr();
    _stage = getStage(egfr);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: newBlue,
        title: Text("Calculation Results",style: _appBarStyle,),
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
                Text("Stage "+_stage, style: _basicText,),
                SizedBox(height: 5),
                Text("eGFR: "+ _calculation.getEgfr().toString(),style: _basicText,),
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
                        child: Text("Save",style: _basicText,),
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
                        child: Text("Discard",style: _basicText,)
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