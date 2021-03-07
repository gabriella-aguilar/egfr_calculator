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
  int _fontShift;
  int _slider;
  bool _unit;
  Account _account;
  TextStyle _appBarStyle;
  TextStyle _basicText;

  void setStyles() async{
    String email = Provider.of<ContextInfo>(context, listen: false).getCurrentAccount().getEmail();
    int f = await DataAccess.instance.getFontSize(email);
    setState(() {
      _slider = f;
      _fontShift = f;
      _appBarStyle = appBarStyle.copyWith(fontSize: 18 + f.toDouble());
      _basicText = basicText.copyWith(fontSize: 18 + f.toDouble());

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: newBlue,
        title: Text("Settings",style: _appBarStyle,),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: backBlue,
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
            activeColor: darkBlueAccent,
            inactiveColor: newBlue,
            min: 0,
            max: 10,
            divisions: 5,
            onChanged: (double value) {
              setState(() {
                _slider = value.round();
              });
            },
          ),
          ElevatedButton(
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

    DataAccess.instance.updateUnit(account);
    DataAccess.instance.updateFontSize(account.getEmail(), _slider);
    Provider.of<ContextInfo>(context,listen: false).setCurrentAccount(account);

  }
}