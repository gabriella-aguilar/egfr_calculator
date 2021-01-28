import 'package:flutter/material.dart';
import 'package:egfr_calculator/Screens/LoginScreen.dart';
import 'package:egfr_calculator/Colors.dart';
import 'package:provider/provider.dart';
import 'package:egfr_calculator/Context.dart';
void main() {
  runApp(
      ChangeNotifierProvider(
          create: (context) => ContextInfo(),
          child: MyApp()
      )
  );
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: trackData,
      home: LoginPage(),
    );
  }
}



