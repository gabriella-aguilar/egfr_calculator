import 'package:egfr_calculator/Classes/CalculationClass.dart';
import 'package:egfr_calculator/Classes/ProfileClass.dart';
import 'package:egfr_calculator/DataAccess.dart';
import 'package:flutter/material.dart';
import 'package:egfr_calculator/Context.dart';
import 'package:provider/provider.dart';

import '../Colors.dart';
class PreEditDataPage extends StatefulWidget{
  @override
  _PreEditDataPageState createState() => _PreEditDataPageState();
}

class _PreEditDataPageState extends State<PreEditDataPage> {

  List<Calculation> _list;

  @override
  void initState() {
    _setUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: newBlue,
      title: Text("Profiles",style: appBarStyle,),
      centerTitle: true,
    ),
      body: ListView(
        children: _getData(),
      ),
    );
  }


  _setUp() async{
    Profile profile = Provider.of<ContextInfo>(context, listen: false).getCurrentProfile();
    List<Calculation> l = await DataAccess.instance.getCalculations(profile.getAccount(), profile.getName());
    _list = new List<Calculation>();
    if(l != null && l.isNotEmpty){
      setState(() {
        _list.addAll(l);
      });
    }
  }

  List<Widget> _getData() {
    List<Widget> wids = new List<Widget>();
    if(_list!= null && _list.isNotEmpty){
      _list.forEach((element) {
        wids.add(Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          decoration: BoxDecoration(
            color: backBlue,
            border: Border(
              bottom: BorderSide(width: 1.0, color: darkBlueAccent),
            ),
          ),
          child: ListTile(
            title: Text(element.getEgfr().toString(),style: basicText,),
            subtitle: Text(element.getDate()),
            trailing: IconButton(icon: Icon(Icons.delete),
              onPressed: (){
                DataAccess.instance.deleteCalculation(element.getDate(), element.getProfile(), element.getAccount());
            },),

          ),
        ));
      });
    }
    else{
      wids.add(Text("No Data"));
    }
    return wids;
  }
}