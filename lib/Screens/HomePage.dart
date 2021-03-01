import 'package:egfr_calculator/Screens/EditProfile.dart';
import 'package:egfr_calculator/Screens/SettingsScreen.dart';
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
      IconButton(icon: Icon(Icons.settings,color: Colors.white,), onPressed: (){
        Navigator.pop(context);
        Navigator.push(
          context,
          PageRouteBuilder(pageBuilder: (_, __, ___) => SettingsScreen()),
        );
      }),
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
        //padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
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
        wids.add(GestureDetector(
          onTap:(){
            if(mode){
            Provider.of<ContextInfo>(context, listen: false).setCurrentProfile(element);
            Navigator.push(
              context,
              PageRouteBuilder(pageBuilder: (_, __, ___) => ViewProfilePage()),
            );}
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
            decoration: BoxDecoration(
              color: backBlue,
              border: Border(
                bottom: BorderSide(width: 1.0, color: darkBlueAccent),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(element.getName(),style: basicText,),
                Opacity(
                  opacity: mode ? 0.0 : 1.0,
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: Icon(Icons.edit,color: newBlue,),
                        onPressed: (){
                          if(!mode) {
                            Provider.of<ContextInfo>(context, listen: false)
                                .setCurrentProfile(element);
                            _updateProf();
                          }
                        },

                    ),
                    IconButton(icon: Icon(Icons.delete,color: newBlue,), onPressed: (){
                      if(!mode) {
                        _deleteProf(element.getName());
                      }
                    }),
                  ],
              ),
                ),
              ],
            )
          ),
        ));
      });
    }
    else{
      wids.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("No Profiles",style: basicText,)
          ],
        ),
      ));
    }
    return wids;
  }

  _updateProf(){
    Navigator.pop(context);
    Navigator.push(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => EditProfileScreen()),
    );
  }

  _deleteProf(String name) async{
    String account = Provider.of<ContextInfo>(context, listen: false).getCurrentAccount().getEmail();
    DataAccess.instance.deleteProfile(name, account);
    _setUp();
  }
}