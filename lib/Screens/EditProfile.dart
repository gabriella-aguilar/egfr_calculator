import 'package:egfr_calculator/Classes/ProfileClass.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Colors.dart';
import '../Context.dart';
import '../DataAccess.dart';
import 'HomePage.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _dob;
  DateTime _date;
  String _nameController;
  Icon womanButton;
  Icon manButton;
  bool _gender; //true -> female false->male
  bool _ethnicity;
  String _error;

  @override
  void initState() {
    Profile profile =
        Provider.of<ContextInfo>(context, listen: false).getCurrentProfile();
    _date = DateTime.parse(profile.getDOB());
    _dob = dateFormat(_date);
    _nameController = profile.getName();
    if (profile.getEthnicity() == 1) {
      _ethnicity = true;
    } else {
      _ethnicity = false;
    }
    if (profile.getGender() == 1) {
      _gender = true;
    } else {
      _gender = false;
    }
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
        backgroundColor: newBlue,
        title: Text(
          "Edit Profile",
          style: appBarStyle,
        ),
        centerTitle: true,
      ),
      body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
          children: [
            Text(
              _error,
              style: errorTextStyle,
            ),
            Text(
              "Name",
              style: basicText,
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              initialValue: _nameController,
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
                    onPressed: () {
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
                    onPressed: () {
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
                Text(
                  'Black Ethnicity',
                  style: basicText,
                ),
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
                onPressed: _submit,
                child: Text("Submit"))
          ]),
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

  _submit() {
    if (_nameController != "" && _dob != dateFormat(DateTime.now())) {
      Profile profile = new Profile(
          name: _nameController,
          dob: _date.toString(),
          ethnicity: (_ethnicity ? 1 : 0),
          gender: (_gender ? 1 : 0),
          account: Provider.of<ContextInfo>(context, listen: false)
              .getCurrentAccount()
              .getEmail());
      String name = Provider.of<ContextInfo>(context, listen: false)
          .getCurrentProfile()
          .getName();
      String email = Provider.of<ContextInfo>(context, listen: false)
          .getCurrentAccount()
          .getEmail();
      DataAccess.instance.updateProfile(name, email, profile);
      Navigator.pop(context);
      Navigator.push(
        context,
        PageRouteBuilder(pageBuilder: (_, __, ___) => HomePage()),
      );
    } else {
      setState(() {
        _error = "Fields cannot be left blank";
      });
    }
  }
}
