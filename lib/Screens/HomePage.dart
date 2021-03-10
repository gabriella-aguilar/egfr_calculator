import 'package:egfr_calculator/Screens/EditProfile.dart';
import 'package:egfr_calculator/Screens/LoginScreen.dart';
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

  bool mode; //true -> normal false-> editing
  List<Profile> profiles;
  int _fontShift = 0;
  TextStyle _appBarStyle;
  TextStyle _basicText;
  Color _newBlue;
  Color _darkBlueAccent;
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
    mode = true;
    setStyles();
    _setUp();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> reg = [
      IconButton(icon: Icon(Icons.settings,color: _iconColor,size: 24 + _fontShift.toDouble(),), onPressed: (){
        Navigator.pop(context);
        Navigator.push(
          context,
          PageRouteBuilder(pageBuilder: (_, __, ___) => SettingsScreen()),
        );
      }),
      IconButton(icon: Icon(Icons.edit,color: _iconColor,size: 24 + _fontShift.toDouble(),), onPressed: (){
        setState(() {
          mode = false;
        });
      }),
      IconButton(icon: Icon(Icons.add_circle,color: _iconColor,size: 24 + _fontShift.toDouble(),), onPressed: (){
      Navigator.pop(context);
      Navigator.push(
        context,
        PageRouteBuilder(pageBuilder: (_, __, ___) => AddProfilePage()),
      );
    }),
    ];

    List<Widget> editting = [
      IconButton(icon: Icon(Icons.done,color: _iconColor,size: 24 + _fontShift.toDouble(),), onPressed: (){
        setState(() {
          mode = true;
        });
      }),
    ];

    if(_newBlue == null){
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon:  Icon(
                  Icons.arrow_back,
                  color: _iconColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => LoginPage()),
                  );
                },
              );
              //return Container();
            },
          ),
        backgroundColor: _appBarBack,
        title: Text("Profiles",style: _appBarStyle,),
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
      setState(() {
        mode = true;
      });
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
                bottom: BorderSide(width: 1.0, color: _darkBlueAccent),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(element.getName(),style: _basicText,),
                Opacity(
                  opacity: mode ? 0.0 : 1.0,
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: Icon(Icons.edit,color: _newBlue,size: 24 + _fontShift.toDouble(),),
                        onPressed: (){
                          if(!mode) {
                            Provider.of<ContextInfo>(context, listen: false)
                                .setCurrentProfile(element);
                            _updateProf();
                          }
                        },

                    ),
                    IconButton(icon: Icon(Icons.delete,color: _newBlue,size: 24 + _fontShift.toDouble(),), onPressed: (){
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
            Text("No Profiles",style: _basicText,)
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