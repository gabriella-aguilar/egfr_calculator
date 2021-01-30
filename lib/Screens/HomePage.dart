import 'package:egfr_calculator/Screens/ViewProfile.dart';
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

  bool mode; //true -> normal false-> editting
  List<Profile> profiles;

  @override
  void initState() {
    mode = true;
    super.initState();
    _setUp();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> reg = [
      IconButton(icon: Icon(Icons.edit,color: Colors.white,), onPressed: (){
        setState(() {
          mode = false;
        });
      }),
      IconButton(icon: Icon(Icons.add_circle,color: Colors.white,), onPressed: (){
      Navigator.pop(context);
      Navigator.push(
        context,
        PageRouteBuilder(pageBuilder: (_, __, ___) => AddProfilePage()),
      );
    }),
    ];

    List<Widget> editting = [
      IconButton(icon: Icon(Icons.done,color: Colors.white,), onPressed: (){
        setState(() {
          mode = true;
        });
      }),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: newBlue,
        title: Text("Profiles",style: appBarStyle,),
        centerTitle: true,
        actions:mode ? reg : editting
      ),
      body: ListView(

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
        wids.add(Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          decoration: BoxDecoration(
            color: backBlue,
            border: Border(
              bottom: BorderSide(width: 1.0, color: darkBlueAccent),
            ),
          ),
          child: ListTile(
            title: Text(element.getName(),style: basicText,),
            trailing: mode ? null : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(icon: Icon(Icons.edit,color: newBlue,), onPressed: (){

                }),
                IconButton(icon: Icon(Icons.delete,color: newBlue,), onPressed: (){
                  _deleteProf(element.getName());
                }),
              ],
            ),
            onTap: (){
              if(mode){
              Provider.of<ContextInfo>(context, listen: false).setCurrentProfile(element);
              Navigator.push(
                context,
                PageRouteBuilder(pageBuilder: (_, __, ___) => ViewProfilePage()),
              );}
            },
          ),
        ));
      });
    }
    else{
      wids.add(Text("No Profiles"));
    }
    return wids;
  }

  _deleteProf(String name) async{
    String account = Provider.of<ContextInfo>(context, listen: false).getCurrentAccount().getEmail();
    DataAccess.instance.deleteProfile(name, account);
    _setUp();
  }
}