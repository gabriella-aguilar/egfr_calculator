import 'package:flutter/material.dart';

import '../Colors.dart';

class AddProfilePage extends StatefulWidget{
  @override
  _AddProfilePageState createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  String _dob;
  String _nameController;


  @override
  void initState() {
    super.initState();
    _dob = dateFormat(DateTime.now());
    _nameController = "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a Profile",style: appBarStyle,),
        backgroundColor: newBlue,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        children: [
          Text("Name",style: basicText,),
          SizedBox(height: 5,),
          TextField(
            decoration: inputDecoration,
            onChanged: (value){
              _nameController = value;
            },
          ),
          Row(
            children: [
              Text("DOB",style: basicText,),
              SizedBox(width: 10),
              FlatButton(
                //elevation: 8.0,
                  child: Text(_dob),
                  textColor: backBlue,
                  color: newBlue,
                  onPressed: () => _selectDate(context)),
            ],
          ),
          ElevatedButton(
              style: elevatedButtonStyle,
              onPressed: (){

              },
              child: Text("Submit")
          )],

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
}