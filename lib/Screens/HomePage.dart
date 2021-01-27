
import 'package:flutter/material.dart';
import '../Colors.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: newBlue,
        title: Text("Profiles",style: appBarStyle,),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        children: [

        ],
      ),
    );
  }


  List<Widget> _getProfiles() {
    List<Widget> profiles = new List<Widget>();
    return profiles;
  }
}