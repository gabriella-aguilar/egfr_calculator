import 'package:egfr_calculator/Classes/AccountsClass.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egfr_calculator/DataAccess.dart';
import '../Colors.dart';
import '../Context.dart';

class SettingsScreen extends StatefulWidget{
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool _unit;
  Account _account;

  @override
  void initState() {
    _account = Provider.of<ContextInfo>(context,listen: false).getCurrentAccount();
    if(_account.getUnit() == 1){
      _unit = true;
    }
    else{
      _unit = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: newBlue,
        title: Text("Settings",style: appBarStyle,),
        centerTitle: true,
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
                          : Icons.radio_button_unchecked)),
                      Text(
                        "mmol/L",
                        style: basicText,
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
                          : Icons.radio_button_checked)),
                      Text(
                        "mg/dl",
                        style: basicText,
                      )
                    ],
                  )),

            ],
          ),
          ElevatedButton(
              onPressed: (){
                _update();
              },
              child: Text("Save",style: basicText,)
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

    Provider.of<ContextInfo>(context,listen: false).setCurrentAccount(account);

  }
}