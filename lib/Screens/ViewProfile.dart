import 'package:egfr_calculator/Classes/CalculationClass.dart';
import 'package:egfr_calculator/Classes/ProfileClass.dart';
import 'package:egfr_calculator/DataAccess.dart';
import 'package:egfr_calculator/Screens/NewCalculationScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egfr_calculator/Context.dart';
import 'package:egfr_calculator/Colors.dart';

class ViewProfilePage extends StatefulWidget{
  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  Profile _profile;
  List<Calculation> _calculations;

  @override
  void initState() {
    super.initState();
    _profile = Provider.of<ContextInfo>(context, listen: false).getCurrentProfile();
    _getCalculations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: newBlue,
        title: Text(_profile.getName(),style: appBarStyle,),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        children: [
          Text(_profile.getName(),style: basicText),
          Text("DOB: "+_profile.getDOB(),style: basicText,),
          Text("Gender: "+ (_profile.getGender() == 1 ? "Female" : "Male"),style: basicText,),
          Text("Black Ethnicity: "+ (_profile.getEthnicity() == 1 ? "Yes" : "No"), style: basicText,),
          ButtonBar(
            children: [
              ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(pageBuilder: (_, __, ___) => NewCalculationPage()),
                  );
                },
                child: Column(
                  children: [
                    Icon(Icons.add_box_rounded),
                    Text("New eGFR\nCalculation")
                  ],
                ),
                style: elevatedButtonStyle,
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(pageBuilder: (_, __, ___) => NewCalculationPage()),
                  );
                },
                child: Column(
                  children: [
                    Icon(Icons.edit),
                    Text("Edit Data")
                  ],
                ),
                style: elevatedButtonStyle,
              )
            ],
          ),
        ],
      ),
    );
  }

  _getCalculations() async{
    _calculations = new List<Calculation>();

    List<Calculation> c = await DataAccess.instance.getCalculations(_profile.getAccount(), _profile.getName());
    if(c != null && c.isNotEmpty){
      print("Num Calcs "+c.length.toString());
      setState(() {
        _calculations.addAll(c);
      });
    }
  }

}