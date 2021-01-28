import 'package:egfr_calculator/Classes/ProfileClass.dart';
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

  @override
  void initState() {
    super.initState();
    _profile = Provider.of<ContextInfo>(context, listen: false).getCurrentProfile();
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

                },
                child: Column(
                  children: [
                    Icon(Icons.add_box_rounded),
                    Text("New eGFR\nCalculation")
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
}