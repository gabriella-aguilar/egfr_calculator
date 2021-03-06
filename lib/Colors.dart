import 'package:flutter/material.dart';

const newBlue =  Colors.blue;
const newBlue2 =  Colors.blueGrey;
const darkBlueAccent = Colors.black;
const darkBlueAccent2 = const Color(0xFF3C426B);
const backBlue = Colors.white;
//const backBlue2 = Colors.whi;
const basicText = TextStyle(
    fontSize: 18,
    //color: darkBlueAccent
);

TextStyle appBarStyle = TextStyle(color: Colors.white,fontSize: 18);

const flatButtonText = TextStyle(
  color: newBlue,
  fontSize: 18
);

InputDecoration inputDecoration = InputDecoration(
  fillColor: Colors.white,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: darkBlueAccent, ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: darkBlueAccent, ),
  ),
  border: OutlineInputBorder(
    borderSide: BorderSide(color: darkBlueAccent, ),
  ),
);

var elevatedButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(newBlue),
    textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(color: Colors.white,fontSize: 18)),
);

TextStyle errorTextStyle = TextStyle(
  color: Colors.red,
  fontSize: 18,
  fontWeight: FontWeight.bold
);

final ThemeData trackData = _buildTrackTheme();

ThemeData _buildTrackTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    // primaryColor: backBlue,
    // backgroundColor: backBlue,
    // accentColor: newBlueAccent,
    // cardColor: backBlue,
    // splashColor: newBlueAccent,
    // highlightColor: newBlueAccent,

    scaffoldBackgroundColor: backBlue,
    textTheme: _buildTrackTextTheme(base.textTheme),
    primaryTextTheme: _buildTrackTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTrackTextTheme(base.accentTextTheme),
    inputDecorationTheme: InputDecorationTheme(
      // filled: true,
      //   fillColor: backBlue,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: darkBlueAccent),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: darkBlueAccent),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: darkBlueAccent),
        ),
        labelStyle: TextStyle(color: darkBlueAccent)
    ),
  );
}

TextTheme _buildTrackTextTheme(TextTheme base) {
  return base
      .copyWith(
    headline5: base.headline5.copyWith(
      fontWeight: FontWeight.w500,
    ),
    headline6: base.headline6.copyWith(fontSize: 18.0),

    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
  )
      .apply(
    fontFamily: 'Rubik',
    displayColor: darkBlueAccent,
    bodyColor: darkBlueAccent,
  );
}

String dateFormat(DateTime d) {
  String sDate = d.day.toString() +
      '-' +
      d.month.toString() +
      '-' +
      d.year.toString();
  return sDate;
}

String getStage(double egfr){
  if(egfr >= 90){
   return "1";
  }
  else if(egfr < 90 && egfr >= 60){
    return "2";
  }
  else if(egfr < 60 && egfr >= 45){
    return "3A";
  }
  else if(egfr < 45 && egfr >= 30){
    return "3B";
  }
  else if(egfr < 30 && egfr >= 15){
    return "4";
  }
  else{
    return "5";
  }
}

