import 'package:flutter/material.dart';
import 'package:egfr_calculator/Classes/CalculationClass.dart';
import 'package:egfr_calculator/Classes/ProfileClass.dart';
import 'package:egfr_calculator/DataAccess.dart';
import 'package:provider/provider.dart';
import 'package:egfr_calculator/Context.dart';
import 'package:egfr_calculator/Colors.dart';
import 'package:egfr_calculator/Components/CalcTable.dart';

class ExportPage extends StatefulWidget {
  @override
  _ExportPageState createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  List<Calculation> _calculations;

  @override
  void initState() {
    Profile profile =
        Provider.of<ContextInfo>(context, listen: false).getCurrentProfile();
    _getCalculations(profile);
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
    return Scaffold(
      body: ListView(
        children: [
          Card(child: CalcTable(),)
        ],
      ),
    );
  }

  Widget getTable() {
    if (_calculations != null && _calculations.isNotEmpty) {
      List<DataRow> rows = new List();
      _calculations.forEach((element) {
        DateTime date = DateTime.parse(element.getDate());
        rows.add(DataRow(cells: [
          DataCell(Text(dateFormat(date))),
          DataCell(Text(element.getEgfr().toString())),
          DataCell(Text(getStage(element.getEgfr())))
        ]));
      });
      return DataTable(columns: [
        DataColumn(
          label: Text(
            'Date',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'EGFR',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Stage',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ], rows: rows);
    }
    return Container();
  }

}
