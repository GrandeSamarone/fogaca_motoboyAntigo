
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fogaca_app/Assistencia/StorageManager.dart';

class ThemeChanger extends ChangeNotifier{
  bool _darkStatus=false;
  isDark()=>_darkStatus;

  setDarkStatus(bool status)async{
    _darkStatus=status;
    if(status==true){
      StorageManager.saveData('themeMode', true);
    }else{
      StorageManager.saveData('themeMode', false);
    }
    notifyListeners();

  }

  ThemeChanger() {
    StorageManager.readData('themeMode').then((value) {
    //  print('value read from storage: ' + value.toString());
      var themeMode = value ?? false;
      if (themeMode == false) {
        _darkStatus=false;
      } else {
        _darkStatus=true;

      }
      notifyListeners();
    });
  }
}