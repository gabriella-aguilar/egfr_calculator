import 'package:provider/provider.dart';
import 'package:egfr_calculator/Context.dart';
import 'package:egfr_calculator/Classes/ProfileClass.dart';
import 'package:egfr_calculator/DataAccess.dart';
import 'package:egfr_calculator/Screens/AddProfile.dart';
import 'package:flutter/material.dart';
import '../Colors.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Profile> profiles;

  @override
  void initState() {
    super.initState();
    _setUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: newBlue,
        title: Text("Profiles",style: appBarStyle,),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.add_circle,color: Colors.white,), onPressed: (){
            Navigator.pop(context);
            Navigator.push(
              context,
              PageRouteBuilder(pageBuilder: (_, __, ___) => AddProfilePage()),
            );
          })
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        children: _getProfiles(),
      ),
    );
  }

  _setUp() async{
    List<Profile> p = await DataAccess.instance.getAllProfiles(Provider.of<ContextInfo>(context, listen: false).getCurrentAccount().getEmail());
    profiles = new List<Profile>();
    if(p != null && p.isNotEmpty){
      setState(() {
        profiles.addAll(p);
      });
    }
    else{
      print("Profiles is empty or null");
    }
  }

  List<Widget> _getProfiles() {
    List<Widget> wids = new List<Widget>();
    if(profiles != null && profiles.isNotEmpty){
      profiles.forEach((element) {
        wids.add(ListTile(
          title: Text(element.getName(),style: basicText,),
        ));
      });
    }
    else{
      wids.add(Text("No Profiles"));
    }
    return wids;
  }
}