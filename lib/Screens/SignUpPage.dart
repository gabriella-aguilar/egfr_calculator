import 'package:egfr_calculator/Classes/AccountsClass.dart';
import 'package:flutter/material.dart';
import 'package:egfr_calculator/Colors.dart';
import 'package:provider/provider.dart';
import 'package:egfr_calculator/Context.dart';
import '../DataAccess.dart';
import 'HomePage.dart';
class SignUpPage extends StatefulWidget{
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _emailController;
  String _confirmEmailController;
  String _passwordController;
  String _confirmPasswordController;
  String _error;

  @override
  void initState() {
    super.initState();
    _emailController = "";
    _passwordController = "";
    _error = "";
  }

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
           Text(_error,style: errorTextStyle,),
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
           ElevatedButton(
               style: elevatedButtonStyle,
               onPressed: (){
                 _signUp();
               },
               child: Text("Sign Up")
           )
         ],
       )],
     )
   );
  }

  _signUp() async{

    if(MediaQuery.of(context).viewInsets.bottom != 0){
      FocusScope.of(context).unfocus();
    }

    if(_emailController == "" || _passwordController == "" || _confirmEmailController == "" || _confirmPasswordController == ""){
      setState(() {
        _error = "Fields cannot be left blank";
      });
    }
    else if(_emailController != _confirmEmailController){
      setState(() {
        _error = "Emails don't match";
      });
    }
    else if(_passwordController != _confirmPasswordController){
      setState(() {
        _error = "Passwords don't match";
      });
    }
    else{
      Account account = new Account(
          email: _emailController,
          password: _passwordController,
          unit: 1
      );

      DataAccess.instance.insertAccount(account);
      Provider.of<ContextInfo>(context, listen: false).setCurrentAccount(account);
      Navigator.pop(context);
      Navigator.push(
        context,
        PageRouteBuilder(pageBuilder: (_, __, ___) => HomePage()),
      );
    }



  }

}