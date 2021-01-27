import 'package:flutter/material.dart';

const newBlue =  const Color(0xFF7986CB);
const newBlue2 =  const Color(0xEE8986CB);
const darkBlueAccent = const Color(0xFF1A237E);
const darkBlueAccent2 = const Color(0xFF3C426B);
const backBlue = const Color(0xFFE8EAF6);
const backBlue2 = const Color(0xFFCACEE8);
const basicText = TextStyle(
    fontSize: 18,
    //color: darkBlueAccent
);

TextStyle appBarStyle = TextStyle(color: Colors.white);

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

