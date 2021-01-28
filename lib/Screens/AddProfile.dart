import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../Colors.dart';

class AddProfilePage extends StatefulWidget {
  @override
  _AddProfilePageState createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  String _dob;
  String _nameController;
  Icon womanButton;
  Icon manButton;
  bool _gender; //true -> female false->male
  bool _ethnicity;

  @override
  void initState() {
    super.initState();
    _dob = dateFormat(DateTime.now());
    _nameController = "";
    _gender = true;
    _ethnicity = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add a Profile",
          style: appBarStyle,
        ),
        backgroundColor: newBlue,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        children: [
          Text(
            "Name",
            style: basicText,
          ),
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
                          : Icons.radio_button_unchecked)),
                      Text(
                        "Female",
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
                        style: basicText,
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
              Text('Black Ethnicity',style: basicText,),
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
                style: basicText,
              ),
              SizedBox(width: 10),
              FlatButton(
                  //elevation: 8.0,
                  child: Text(_dob),
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
              onPressed: () {},
              child: Text("Submit"))
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        // _dobController.text = sDate;
        _dob = dateFormat(picked);
      });
    }
  }

  String dateFormat(DateTime d) {
    String sDate = d.day.toString() +
        ' - ' +
        d.month.toString() +
        ' - ' +
        d.year.toString();
    return sDate;
  }

  _genderToggle(String id) {
    if (id == "w") {
      setState(() {
        womanButton = Icon(Icons.radio_button_checked);
        manButton = Icon(Icons.radio_button_unchecked);
      });
    } else {
      womanButton = Icon(Icons.radio_button_unchecked);
      manButton = Icon(Icons.radio_button_checked);
    }
  }
}
