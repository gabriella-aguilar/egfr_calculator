import 'package:egfr_calculator/Classes/CalculationClass.dart';
import 'package:egfr_calculator/Classes/ProfileClass.dart';
import 'package:egfr_calculator/Components/CalcTable.dart';
import 'package:egfr_calculator/DataAccess.dart';
import 'package:egfr_calculator/Screens/ExportPage.dart';
import 'package:egfr_calculator/Screens/NewCalculationScreen.dart';
import 'package:egfr_calculator/Screens/PreEditDataPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egfr_calculator/Context.dart';
import 'package:egfr_calculator/Colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ViewProfilePage extends StatefulWidget {
  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  Profile _profile;
  List<Calculation> _calculations;

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  void initState() {
    super.initState();
    _calculations = new List<Calculation>();
    _profile = Provider.of<ContextInfo>(context, listen: false).getCurrentProfile();
    _getCalculations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: newBlue,
        title: Text(
          _profile.getName(),
          style: appBarStyle,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        children: [
          Text(_profile.getName(), style: basicText),
          Text(
            "DOB: " + dateFormat(DateTime.parse(_profile.getDOB())),
            style: basicText,
          ),
          Text(
            "Gender: " + (_profile.getGender() == 1 ? "Female" : "Male"),
            style: basicText,
          ),
          Text(
            "Black Ethnicity: " + (_profile.getEthnicity() == 1 ? "Yes" : "No"),
            style: basicText,
          ),
          SizedBox(
            height: 5,
          ),
           _calcGraph(),
          SizedBox(height: 5,),
          // _getSplineChart(),
          //_getCalcListCard(),
          _getCalcTableCard(),
          SizedBox(height: 5,),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) => NewCalculationPage()),
              );
            },
            child: Row(
              children: [
                Icon(Icons.add_box_rounded),
                Text("New eGFR Calculation")
              ],
            ),
            style: elevatedButtonStyle,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) => PreEditDataPage()),
              );
            },
            child: Row(
              children: [Icon(Icons.edit), Text("Edit Data")],
            ),
            style: elevatedButtonStyle,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ExportPage()),
              );
            },
            child: Row(
              children: [Icon(Icons.share), Text("Export")],
            ),
            style: elevatedButtonStyle,
          ),
        ],
      ),
    );
  }

  Widget _calcGraph() {
    List<FlSpot> spots = new List<FlSpot>();
    _calculations.forEach((element) {
      DateTime date = DateTime.parse(element.getDate());
      double x = date.month + (date.day /30);
      double egfr = element.getEgfr();
      spots.add(FlSpot(x,egfr));
    });

    if(spots == null || spots.isEmpty){
      return Container(height: 0,);
    }

    return AspectRatio(
      aspectRatio: 1.5,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: darkBlueAccent),
            borderRadius: BorderRadius.all(
                Radius.circular(10.0) //
            ),
          ),
          child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xff37434d),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: const Color(0xff37434d),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    getTextStyles: (value) =>
                    const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
                    getTitles: (value) {
                      switch (value.toInt()) {
                        case 2:
                          return 'MAR';
                        case 5:
                          return 'JUN';
                        case 8:
                          return 'SEP';
                      }
                      return '';
                    },
                    margin: 8,
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (value) => const TextStyle(
                      color: Color(0xff67727d),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    getTitles: (value) {
                      switch (value.toInt()) {
                        case 1:
                          return '10k';
                        case 3:
                          return '30k';
                        case 5:
                          return '50k';
                      }
                      return '';
                    },
                    reservedSize: 28,
                    margin: 12,
                  ),
                ),
                borderData:
                FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 120,
                lineBarsData: [
                  LineChartBarData(
                    spots:spots,
                    // [
                    //   FlSpot(0, 3),
                    //   FlSpot(2.6, 2),
                    //   FlSpot(4.9, 5),
                    //   FlSpot(6.8, 3.1),
                    //   FlSpot(8, 4),
                    //   FlSpot(9.5, 3),
                    //   FlSpot(11, 4),
                    // ],
                    isCurved: true,
                    colors: gradientColors,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: false,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                    ),
                  ),
                ],
              )
          ),
        )
    );
  }

  List<FlSpot> _getSpots(){
    List<FlSpot> spots = new List<FlSpot>();
    _calculations.forEach((element) {
      DateTime date = DateTime.parse(element.getDate());
      double x = date.month + (date.day / 30);
      spots.add(FlSpot(x,element.getEgfr()));
    });
    return spots;
    //   [
    //   FlSpot(0, 3),
    //   FlSpot(2.6, 2),
    //   FlSpot(4.9, 5),
    //   FlSpot(6.8, 3.1),
    //   FlSpot(8, 4),
    //   FlSpot(9.5, 3),
    //   FlSpot(11, 4),
    // ];
  }

  Widget _getSplineChart(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: darkBlueAccent),
        borderRadius: BorderRadius.all(Radius.circular(10.0) //
        ),
      ),
      child: SfCartesianChart(
          series: <ChartSeries>[
            // Renders spline chart
            SplineSeries<Calculation, double>(
                dataSource: _calculations,
                xValueMapper: (Calculation calc, _) => DateTime.parse(calc.getDate()).month.toDouble(),
                yValueMapper: (Calculation calc, _) => calc.getEgfr()
            )
          ]
      ),
    );
  }

  _getCalculations() async {
    List<Calculation> c = await DataAccess.instance
        .getCalculations(_profile.getAccount(), _profile.getName());
    if (c != null && c.isNotEmpty) {
      print("Num Calcs " + c.length.toString());
      setState(() {
        _calculations.addAll(c);
      });
    }
  }

  Widget _getCalcListCard(){
    if(_calculations != null && _calculations.isNotEmpty){
      List<Widget> tiles = new List<Widget>();
      _calculations.forEach((element) {
        double egfr = element.getEgfr();
        String _stage = "Stage ";
        if(egfr >= 90){
          _stage += "1";
        }
        else if(egfr < 90 && egfr >= 60){
          _stage += "2";
        }
        else if(egfr < 60 && egfr >= 45){
          _stage += "3A";
        }
        else if(egfr < 45 && egfr >= 30){
          _stage += "3B";
        }
        else if(egfr < 30 && egfr >= 15){
          _stage += "4";
        }
        else{
          _stage += "5";
        }
        tiles.add(ListTile(
          title: Text(dateFormat(DateTime.parse(element.getDate())),style: basicText,),
          subtitle: Text(element.getEgfr().toString()),
          trailing: Text(_stage,style:basicText),
        ));
      });
      return Container(
        //padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: darkBlueAccent),
          borderRadius: BorderRadius.all(Radius.circular(10.0) //
          ),
        ),
        child: Column(children: tiles,)

      );
    }
    return Container(height: 0,);
  }

  Widget _getCalcTableCard(){
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: darkBlueAccent),
          borderRadius: BorderRadius.all(Radius.circular(10.0) //
          ),
        ),
        child: CalcTable()

    );
  }
}
