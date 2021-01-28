import 'package:egfr_calculator/Classes/AccountsClass.dart';
import 'package:flutter/foundation.dart';

class ContextInfo extends ChangeNotifier {
  Account _currentAccount;

  Account getCurrentAccount(){return _currentAccount;}
  void setCurrentAccount(Account account){_currentAccount = account;}
}