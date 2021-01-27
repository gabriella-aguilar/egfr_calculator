import 'package:flutter/material.dart';
import 'package:egfr_calculator/Colors.dart';
class SignUpPage extends StatefulWidget{
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _emailController;
  String _confirmEmailController;
  String _passwordController;
  String _confirmPasswordController;
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       backgroundColor: newBlue,
       title: Text("Sign Up",style: appBarStyle,),
       centerTitle: true,
     ),
     body: ListView(
       padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
       children: [Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text("Email",style: basicText),
           SizedBox(height: 5,),
           TextField(
             decoration: inputDecoration,
             onChanged: (value){
               _emailController = value;
             },
           ),
           SizedBox(height: 15,),
           Text("Confirm Email",style: basicText),
           SizedBox(height: 5,),
           TextField(
             decoration: inputDecoration,
             onChanged: (value){
               _confirmEmailController = value;
             },
           ),
           SizedBox(height: 15,),
           Text("Password",style: basicText),
           SizedBox(height: 5,),
           TextField(
             decoration: inputDecoration,
             onChanged: (value){
               _passwordController = value;
             },
           ),
           SizedBox(height: 15,),
           Text("Confirm Password",style: basicText),
           SizedBox(height: 5,),
           TextField(
             decoration: inputDecoration,
             onChanged: (value){
               _confirmPasswordController = value;
             },
           ),
         ],
       )],
     )
   );
  }
}