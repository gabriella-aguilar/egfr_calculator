import 'package:egfr_calculator/Classes/AccountsClass.dart';
import 'package:egfr_calculator/Classes/CalculationClass.dart';
import 'package:egfr_calculator/Classes/ProfileClass.dart';
import 'package:flutter/foundation.dart';

class ContextInfo extends ChangeNotifier {
  Account _currentAccount;
  Profile _currentProfile;
  Calculation _currentCalculation;

  Profile getCurrentProfile(){return _currentProfile;}
  void setCurrentProfile(Profile profile){_currentProfile = profile;}

  Account getCurrentAccount(){return _currentAccount;}
  void setCurrentAccount(Account account){_currentAccount = account;}

  Calculation getCurrentCalculation(){return _currentCalculation;}
  void setCurrentCalculation(Calculation calculation){_currentCalculation = calculation;}
}