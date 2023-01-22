import 'package:flutter/material.dart';

class HomepageProvider extends ChangeNotifier {

  bool showMenu = false;

  changeShowMenuStatus(){
    showMenu = !showMenu;
    notifyListeners();
  }
}
