import 'package:flutter/material.dart';
import 'package:egfr_calculator/Classes/CalculationClass.dart';
import 'package:egfr_calculator/Classes/ProfileClass.dart';
import 'package:egfr_calculator/DataAccess.dart';
import 'package:provider/provider.dart';
import 'package:egfr_calculator/Context.dart';
import 'package:egfr_calculator/Colors.dart';

class CalcTable extends StatefulWidget{
  @override
  _CalcTableState createState() => _CalcTableState();
}

class _CalcTableState extends State<CalcTable> {
  List<Calculation> _calculations;
  Profile profile;
  TextStyle _basicText;
  int _fontSize;

  void setStyles() async{
    String email = Provider.of<ContextInfo>(context, listen: false).getCurrentAccount().getEmail();
    int f = await DataAccess.instance.getFontSize(email);
    setState(() {
      _fontSize = f;
      _basicText = basicText.copyWith(fontSize: 18 + f.toDouble());
    });
  }

  @override
  void initState() {
    profile = Provider.of<ContextInfo>(context, listen: false).getCurrentProfile();
    setStyles();
    _getCalculations(profile);
    super.initState();
  }

  _getCalculations(Profile profile) async {
    List<Calculation> c = await DataAccess.instance
        .getCalculations(profile.getAccount(), profile.getName());
    setState(() {
      _calculations = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_calculations != null && _calculations.isNotEmpty) {
      List<DataRow> rows = new List();
      _calculations.forEach((element) {
        DateTime date = DateTime.parse(element.getDate());

        rows.add(DataRow(cells: [
          DataCell(Text(dateFormat(date),style: _basicText,)),
          DataCell(Text(element.getEgfr().toStringAsFixed(3),style: _basicText,)),
          DataCell(Text(getStage(element.getEgfr()),style: _basicText,)),
          DataCell(IconButton(icon: Icon(Icons.delete,size: 24 + _fontSize.toDouble(),),
            onPressed: (){
              DataAccess.instance.deleteCalculation(element.getDate(), element.getProfile(), element.getAccount());
              _getCalculations(profile);
            },))
        ]));
      });
      return DataTable(
        columnSpacing: 4,
          columns: [
        DataColumn(
          label: Text(
            'Date',
            style: TextStyle(fontStyle: FontStyle.italic,fontSize: 18 + _fontSize.toDouble()),
          ),
        ),
        DataColumn(
          label: Text(
            'EGFR',
            style: TextStyle(fontStyle: FontStyle.italic,fontSize: 18 + _fontSize.toDouble()),
          ),
        ),
        DataColumn(
          label: Text(
            'Stage',
            style: TextStyle(fontStyle: FontStyle.italic,fontSize: 18 + _fontSize.toDouble()),
          ),
        ),
        DataColumn(
          label: Text(
            '',
            style: TextStyle(fontStyle: FontStyle.italic,fontSize: 18 + _fontSize.toDouble()),
          ),
        ),
      ], rows: rows);
    }
    return Container();
  }
}