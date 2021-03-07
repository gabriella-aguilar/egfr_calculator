import 'package:egfr_calculator/Classes/ProfileClass.dart';
import 'package:egfr_calculator/DataAccess.dart';
import 'package:egfr_calculator/Screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:egfr_calculator/Context.dart';
import 'package:provider/provider.dart';
import '../Colors.dart';

class AddProfilePage extends StatefulWidget {
  @override
  _AddProfilePageState createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  String _dob;
  DateTime _date;
  String _nameController;
  Icon womanButton;
  Icon manButton;
  bool _gender; //true -> female false->male
  bool _ethnicity;
  String _error;
  int _fontShift = 0;
  TextStyle _appBarStyle;
  TextStyle _basicText;
  TextStyle _errorText;

  void setStyles() async{
    String email = Provider.of<ContextInfo>(context, listen: false).getCurrentAccount().getEmail();
    int f = await DataAccess.instance.getFontSize(email);
    setState(() {
      _fontShift = f;
      _appBarStyle = appBarStyle.copyWith(fontSize: 18 + f.toDouble());
      _basicText = basicText.copyWith(fontSize: 18 + f.toDouble());
      _errorText = errorTextStyle.copyWith(fontSize: 18 + f.toDouble());
    });
  }

  @override
  void initState() {
    setStyles();
    _dob = dateFormat(DateTime.now());
    _nameController = "";
    _gender = true;
    _ethnicity = false;
    _error = "";
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: backBlue
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
        title: Text(
          "Add a Profile",
          style: _appBarStyle,
        ),
        backgroundColor: newBlue,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        children: [
          Text(_error,style: _errorText,),
          Text(
            "Name",
            style: _basicText),

          SizedBox(
            height: 5,
          ),
          TextField(
            decoration: inputDecoration,
            onChanged: (value) {
              _nameController = value;
            },
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              FlatButton(
                  onPressed: (){
                    setState(() {
                      _gender = true;
                    });
                  },
                  child: Row(
                    children: [
                      Icon((_gender
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked),size: 24 + _fontShift.toDouble(),),
                      Text(
                        "Female",
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
                      _gender = false;
                    });
                  },

                  child: Row(
                    children: [
                      Icon((_gender
                          ? Icons.radio_button_unchecked
                          : Icons.radio_button_checked)),
                      Text(
                        "Male",
                        style: _basicText,
                      )
                    ],
                  )),

            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Black Ethnicity',style: _basicText,),
              Checkbox(
                value: _ethnicity,
                activeColor: darkBlueAccent,
                checkColor: darkBlueAccent,
                onChanged: (value) {
                  setState(() {
                    _ethnicity = value;
                  });
                },
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                "DOB",
                style: _basicText,
              ),
              SizedBox(width: 10),
              FlatButton(
                  //elevation: 8.0,
                  child: Text(_dob,style: _basicText,),
                  textColor: backBlue,
                  color: newBlue,
                  onPressed: () => _selectDate(context)),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
              style: elevatedButtonStyle,
              onPressed: _submit,
              child: Text("Submit",style: _basicText,))
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        // _dobController.text = sDate;
        _date = picked;
        _dob = dateFormat(picked);
      });
    }
  }


  _submit() async{
    String email = Provider.of<ContextInfo>(context, listen: false).getCurrentAccount().getEmail();
    if (_nameController == "" || _dob == dateFormat(DateTime.now())){
      setState(() {
      _error = "Fields cannot be left blank";
      });
    }
    else if(await DataAccess.instance.profileExists(_nameController, email)){
      setState(() {
        _error = "A Profile with this name already exists.";
      });
    }
    else{
      Profile profile = new Profile(
          name: _nameController,
          dob: _date.toString(),
          ethnicity: (_ethnicity ? 1 : 0),
          gender: (_gender ? 1 : 0),
          account: email);
      DataAccess.instance.insertProfile(profile);
      Navigator.pop(context);
      Navigator.push(
        context,
        PageRouteBuilder(pageBuilder: (_, __, ___) => HomePage()),
      );
    }

  }
}
