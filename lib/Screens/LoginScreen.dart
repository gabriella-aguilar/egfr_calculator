import 'package:egfr_calculator/Colors.dart';
import 'package:egfr_calculator/Screens/SignUpPage.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _usernameController;
  String _passwordController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: newBlue,
        title: Text("eGFR Calculator",style: appBarStyle,),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        children: [Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: darkBlueAccent),
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0) //
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 // Text("Login",style: basicText,),
                  Text("Username:",style: basicText,),
                  SizedBox(height: 5,),
                  TextField(
                    decoration: inputDecoration,
                    onChanged: (value){
                      _usernameController = value;
                    },
                  ),
                  SizedBox(height: 15,),
                  Text("Password:",style: basicText,),
                  SizedBox(height: 5,),
                  TextField(
                    obscureText: true,
                    decoration: inputDecoration,
                    onChanged: (value){
                      _passwordController = value;
                    },
                  ),
                  ButtonBar(
                    children:[
                      FlatButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              PageRouteBuilder(pageBuilder: (_, __, ___) => SignUpPage()),
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: flatButtonText
                          )
                      ),
                      ElevatedButton(
                        style: elevatedButtonStyle,
                        onPressed: (){
                          Navigator.push(
                            context,
                            PageRouteBuilder(pageBuilder: (_, __, ___) => SignUpPage()),
                          );
                        },
                        child: Text("Go!")
                    )],
                  )
                ],
              ),
            )
          ],
        )],
      ),
    );
  }
}