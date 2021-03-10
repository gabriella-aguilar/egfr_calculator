import 'package:egfr_calculator/Classes/AccountsClass.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egfr_calculator/DataAccess.dart';
import '../Colors.dart';
import '../Context.dart';
import 'HomePage.dart';

class SettingsScreen extends StatefulWidget{
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _fontShift = 0;
  int _slider;
  bool _unit;
  bool _palette ;
  Account _account;
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
    bool p1 = true;
    if(p == 1){
      color1 = Colors.black;
      color2 = Colors.black;
      aBBack = Colors.white;
      aColor = color1;
      p1 = false;
    }

    setState(() {
      _appBarBack = aBBack;
      _fontShift = f;
      _appBarStyle = appBarStyle.copyWith(fontSize: 18 + f.toDouble(),color: aColor);
      _basicText = basicText.copyWith(fontSize: 18 + f.toDouble());
      _newBlue = color1;
      _darkBlueAccent = color2;
      _iconColor = aColor;
      _palette = p1;
    });
  }

  @override
  void initState() {
    _slider = 0;
    _account = Provider.of<ContextInfo>(context,listen: false).getCurrentAccount();
    if(_account.getUnit() == 1){
      _unit = true;
    }
    else{
      _unit = false;
    }
    setStyles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_newBlue == null){
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarBack,
        title: Text("Settings",style: _appBarStyle,),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.arrow_back,
                color:_iconColor,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  PageRouteBuilder(pageBuilder: (_, __, ___) => HomePage()),
                );
              },
            );
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        children: [
          Text("Unit:",style: _basicText,),
          Row(
            children: [
              FlatButton(
                  onPressed: (){
                    setState(() {
                      _unit = true;
                    });
                  },
                  child: Row(
                    children: [
                      Icon((_unit
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked),size: 24 + _fontShift.toDouble(),),
                      Text(
                        "mmol/L",
                        style: _basicText,
                      )
                    ],
                  )),
              SizedBox(
                height: 5,
              ),
              FlatButton(
                  onPressed: (){
                    setState(() {
                      _unit = false;
                    });
                  },

                  child: Row(
                    children: [
                      Icon((_unit
                          ? Icons.radio_button_unchecked
                          : Icons.radio_button_checked),size: 24 + _fontShift.toDouble(),),
                      Text(
                        "mg/dl",
                        style: _basicText,
                      )
                    ],
                  )),

            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text("Font Size:",style: _basicText,),
          Slider(
            value: _slider.toDouble(),
            activeColor: _darkBlueAccent,
            inactiveColor: _newBlue,
            min: 0,
            max: 10,
            divisions: 5,
            onChanged: (double value) {
              setState(() {
                _slider = value.round();
              });
            },
          ),
          Text("Palette:",style: _basicText,),
          Column(
            children: [
              FlatButton(
                  onPressed: (){
                    setState(() {
                      _palette = true;
                    });
                  },
                  child: Row(
                    children: [
                      Icon((_palette
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked),size: 24 + _fontShift.toDouble(),),
                      Text(
                        "Classic",
                        style: _basicText,
                      )
                    ],
                  )),
              SizedBox(
                height: 5,
              ),
              FlatButton(
                  onPressed: (){
                    setState(() {
                      _palette = false;
                    });
                  },

                  child: Row(
                    children: [
                      Icon((_palette
                          ? Icons.radio_button_unchecked
                          : Icons.radio_button_checked),size: 24 + _fontShift.toDouble(),),
                      Text(
                        "Black and White",
                        style: _basicText,
                      )
                    ],
                  )),

            ],
          ),
          ElevatedButton(
            style: elevatedButtonStyle.copyWith(backgroundColor: MaterialStateProperty.all<Color>(_newBlue)),
              onPressed: (){
                _update();
              },
              child: Text("Save",style: _basicText,)
          )
        ],
      ),
    );
  }

  _update() async{
    int u = 1;
    if(!_unit){
      u = 2;
    }

    Account account = new Account(
        email: _account.getEmail(),
        password: _account.getPassword(),
        unit: u
    );

    int p = 0;
    if(!_palette){
      p = 1;
    }

    DataAccess.instance.updateUnit(account);
    DataAccess.instance.updateFontSize(account.getEmail(), _slider);
    DataAccess.instance.updatePalette(account.getEmail(), p);
    Provider.of<ContextInfo>(context,listen: false).setCurrentAccount(account);
    setStyles();
  }
}