import 'package:egfr_calculator/Classes/CalculationClass.dart';
import 'package:egfr_calculator/Classes/ProfileClass.dart';
import 'package:egfr_calculator/Components/CalcTable.dart';
import 'package:egfr_calculator/DataAccess.dart';
import 'package:egfr_calculator/Screens/NewCalculationScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egfr_calculator/Context.dart';
import 'package:egfr_calculator/Colors.dart';
import 'package:fl_chart/fl_chart.dart';

class ViewProfilePage extends StatefulWidget {
  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  Profile _profile;
  List<Calculation> _calculations;
  String _emailText = 'Export';
  int _fontShift = 0;
  TextStyle _appBarStyle;
  TextStyle _basicText;
  Color _newBlue;
  Color _darkBlueAccent;
  Color _appBarBack;
  Color _iconColor;

  void setStyles() async {
    String email = Provider.of<ContextInfo>(context, listen: false)
        .getCurrentAccount()
        .getEmail();
    int f = await DataAccess.instance.getFontSize(email);
    int p = await DataAccess.instance.getPalette(email);
    Color color1 = newBlue;
    Color color2 = darkBlueAccent;
    Color aBBack = newBlue;
    Color aColor = backBlue;

    if (p == 1) {
      color1 = Colors.black;
      color2 = Colors.black;
      aBBack = Colors.white;
      aColor = color1;
    }

    setState(() {
      _appBarBack = aBBack;
      _fontShift = f;
      _appBarStyle =
          appBarStyle.copyWith(fontSize: 18 + f.toDouble(), color: aColor);
      _basicText = basicText.copyWith(fontSize: 18 + f.toDouble());
      _newBlue = color1;
      _darkBlueAccent = color2;
      _iconColor = aColor;
      gradientColors = [_newBlue, _newBlue];
    });
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  void initState() {
    setStyles();
    _calculations = new List<Calculation>();
    _profile =
        Provider.of<ContextInfo>(context, listen: false).getCurrentProfile();
    _getCalculations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_newBlue == null) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: _iconColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        backgroundColor: _appBarBack,
        title: Text(
          _profile.getName(),
          style: _appBarStyle,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: " + _profile.getName(), style: _basicText),
              SizedBox(
                height: 10,
              ),
              Text(
                "DOB: " + dateFormat(DateTime.parse(_profile.getDOB())),
                style: _basicText,
              ),
              Text(
                "Gender: " + (_profile.getGender() == 1 ? "Female" : "Male"),
                style: _basicText,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Black Ethnicity: " +
                    (_profile.getEthnicity() == 1 ? "Yes" : "No"),
                style: _basicText,
              ),
            ],
          ),

          SizedBox(
            height: 10,
          ),
          _calcGraph(),
          SizedBox(
            height: 10,
          ),
        Container(
        //padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _darkBlueAccent),
            borderRadius: BorderRadius.all(Radius.circular(10.0) //
            ),
          ),
          child: CalcTable()),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) => NewCalculationPage()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_box_rounded,
                    size: 24 + _fontShift.toDouble(), color: backBlue),
                SizedBox(width: 5),
                Text(
                  "New eGFR\nCalculation",
                  style: _basicText.copyWith(color: backBlue),
                )
              ],
            ),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            color: _newBlue,
          ),
          RaisedButton(
            onPressed: () {
              _createTextString();

              print(_emailText);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.share,
                  size: 24 + _fontShift.toDouble(),
                  color: backBlue,
                ),
                SizedBox(width: 5),
                Text(
                  "Export",
                  style: _basicText.copyWith(color: backBlue),
                )
              ],
            ),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            color: _newBlue,
          ),
        ],
      ),
    );
  }

  Widget _calcGraph() {
    _getCalculations();
    List<FlSpot> spots = new List<FlSpot>();
    Map<double, int> titles = new Map();

    List labels = List();
    _calculations.sort((a, b) => a.getDate().compareTo(b.getDate()));
    DateTime startX = null;
    _calculations.forEach((element) {
      DateTime date = DateTime.parse(element.getDate());
      if (startX == null) {
        startX = date;
      }
      Duration dif = date.difference(startX);
      double x = dif.inDays / 30;
      titles[x] = date.month;
      labels.add(date.month);
      double egfr = element.getEgfr();
      spots.add(FlSpot(x, egfr));
    });

    if (spots == null || spots.isEmpty) {
      return Container(
        height: 0,
      );
    }

    return AspectRatio(
        aspectRatio: 1.5,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _darkBlueAccent),
            borderRadius: BorderRadius.all(Radius.circular(10.0) //
                ),
          ),
          child: LineChart(LineChartData(
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
                getTextStyles: (value) => const TextStyle(
                    color: Color(0xff68737d),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
                getTitles: (value) {
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
                    case 125:
                      return '125';
                    case 100:
                      return '100';
                    case 50:
                      return '50';
                    case 75:
                      return '75';
                    case 25:
                      return '25';
                  }
                  return '';
                },
                reservedSize: 28,
                margin: 12,
              ),
            ),
            borderData: FlBorderData(
                show: true,
                border: Border.all(color: const Color(0xff37434d), width: 1)),
            minX: 0,
            maxX: 12,
            minY: 0,
            maxY: 125,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                colors: gradientColors,
                barWidth: 5,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
                belowBarData: BarAreaData(
                  show: true,
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.3))
                      .toList(),
                ),
              ),
            ],
          )),
        ));
  }


  _getCalculations() async {
    List<Calculation> c = await DataAccess.instance
        .getCalculations(_profile.getAccount(), _profile.getName());
    if (c != null && c.isNotEmpty) {
      print("Num Calcs " + c.length.toString());
      setState(() {
        _calculations.clear();
        _calculations.addAll(c);
      });
    }
  }

  _createTextString() {
    String t = '';
    if (_calculations == null || _calculations.isEmpty) {
      print('calc empty');
    }
    _calculations.forEach((element) {
      DateTime date = DateTime.parse(element.getDate());
      t = t +
          dateFormat(date) +
          " Stage " +
          getStage(element.getEgfr()) +
          " " +
          element.getEgfr().toStringAsFixed(3) +
          "\n";
    });

    setState(() {
      _emailText = t;
    });
    _shareText();
  }

  _shareText() async {
    String toMailId = '';
    String subject = 'EGFR Export';
    String body = _emailText;
    _createTextString();
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Widget calcTable() {
  //   if (_calculations != null && _calculations.isNotEmpty) {
  //     List<DataRow> rows = new List();
  //     _calculations.forEach((element) {
  //       DateTime date = DateTime.parse(element.getDate());
  //
  //       rows.add(DataRow(cells: [
  //         DataCell(Text(
  //           dateFormat(date),
  //           style: _basicText,
  //         )),
  //         DataCell(Text(
  //           element.getEgfr().toStringAsFixed(3),
  //           style: _basicText,
  //         )),
  //         DataCell(Text(
  //           getStage(element.getEgfr()),
  //           style: _basicText,
  //         )),
  //         DataCell(IconButton(
  //           icon: Icon(
  //             Icons.delete,
  //             size: 24 + _fontShift.toDouble(),
  //           ),
  //           onPressed: () {
  //             DataAccess.instance.deleteCalculation(element.getDate(),
  //                 element.getProfile(), element.getAccount());
  //             _getCalculations();
  //           },
  //         ))
  //       ]));
  //     });
  //     return DataTable(
  //         columnSpacing: 4,
  //         columns: [
  //           DataColumn(
  //             label: Text(
  //               'Date',
  //               style: TextStyle(
  //                   fontStyle: FontStyle.italic,
  //                   fontSize: 18 + _fontShift.toDouble()),
  //             ),
  //           ),
  //           DataColumn(
  //             label: Text(
  //               'EGFR',
  //               style: TextStyle(
  //                   fontStyle: FontStyle.italic,
  //                   fontSize: 18 + _fontShift.toDouble()),
  //             ),
  //           ),
  //           DataColumn(
  //             label: Text(
  //               'Stage',
  //               style: TextStyle(
  //                   fontStyle: FontStyle.italic,
  //                   fontSize: 18 + _fontShift.toDouble()),
  //             ),
  //           ),
  //           DataColumn(
  //             label: Text(
  //               '',
  //               style: TextStyle(
  //                   fontStyle: FontStyle.italic,
  //                   fontSize: 18 + _fontShift.toDouble()),
  //             ),
  //           ),
  //         ],
  //         rows: rows);
  //   }
  //   return Container();
  // }
}
