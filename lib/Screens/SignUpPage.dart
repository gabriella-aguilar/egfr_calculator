import 'package:egfr_calculator/Classes/AccountsClass.dart';
import 'package:flutter/material.dart';
import 'package:egfr_calculator/Colors.dart';
import 'package:provider/provider.dart';
import 'package:egfr_calculator/Context.dart';
import '../DataAccess.dart';
import 'HomePage.dart';

class SignUpPage extends StatefulWidget {
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
          title: Text(
            "Sign Up",
            style: appBarStyle,
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              decoration: BoxDecoration(
                color: newBlue2,
                border: Border.all(color: darkBlueAccent),
                borderRadius: BorderRadius.all(Radius.circular(30.0) //
                    ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _error,
                    style: errorTextStyle,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: backBlue,
                      borderRadius: BorderRadius.all(
                          Radius.circular(30.0) //
                      ),
                    ),
                    child: TextField(
                      decoration: inputDecoration.copyWith(hintText: "Email"),
                      style: basicText,
                      autocorrect: false,
                      onChanged: (value) {
                        _emailController = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: backBlue,
                      borderRadius: BorderRadius.all(
                          Radius.circular(30.0) //
                      ),
                    ),
                    child: TextField(
                      decoration:
                          inputDecoration.copyWith(hintText: "Confirm Email"),
                      style: basicText,
                      autocorrect: false,
                      onChanged: (value) {
                        _confirmEmailController = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: backBlue,
                      borderRadius: BorderRadius.all(
                          Radius.circular(30.0) //
                      ),
                    ),
                    child: TextField(
                      obscureText: true,
                      autocorrect: false,
                      decoration: inputDecoration.copyWith(hintText: "Password"),
                      style: basicText,
                      onChanged: (value) {
                        _passwordController = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: backBlue,
                      borderRadius: BorderRadius.all(
                          Radius.circular(30.0) //
                      ),
                    ),
                    child: TextField(
                      obscureText: true,
                      autocorrect: false,
                      style: basicText,
                      decoration:
                          inputDecoration.copyWith(hintText: "Confirm Password"),
                      onChanged: (value) {
                        _confirmPasswordController = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton(
                      color: newBlue,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      onPressed: () {
                        _signUp();
                      },
                      child: Text(
                        "Sign Up",
                        style: basicText.copyWith(color: backBlue),
                      ))
                ],
              ),
            )
          ],
        ));
  }

  _signUp() async {
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      FocusScope.of(context).unfocus();
    }
    bool exists = await DataAccess.instance.accountExists(_emailController);

    if (exists) {
      setState(() {
        _error = "An account with this email already exists";
      });
    } else if (_errorChecking()) {
      Account account = new Account(
          email: _emailController, password: _passwordController, unit: 1);

      DataAccess.instance.insertAccount(account);
      Provider.of<ContextInfo>(context, listen: false)
          .setCurrentAccount(account);
      Navigator.pop(context);
      Navigator.push(
        context,
        PageRouteBuilder(pageBuilder: (_, __, ___) => HomePage()),
      );
    }
  }

  bool _errorChecking() {
    //true is all good
    if (_emailController == "" ||
        _passwordController == "" ||
        _confirmEmailController == "" ||
        _confirmPasswordController == "") {
      setState(() {
        _error = "Fields cannot be left blank";
      });
      return false;
    } else if (!_emailController.contains("@") ||
        !_emailController
            .substring(_emailController.indexOf("@"))
            .contains(".")) {
      setState(() {
        _error = "Please enter a valid email";
      });
      return false;
    } else if (_emailController != _confirmEmailController) {
      setState(() {
        _error = "Emails don't match";
      });
      return false;
    } else if (_passwordController != _confirmPasswordController) {
      setState(() {
        _error = "Passwords don't match";
      });
      return false;
    }

    return true;
  }
}
