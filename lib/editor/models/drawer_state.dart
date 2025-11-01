import 'package:flutter/material.dart';

class DrawerStateModel extends ChangeNotifier {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  Widget? child;

  void setScaffoldKey(GlobalKey<ScaffoldState> key) {
    _scaffoldKey = key;
  }

  void showDrawer(Widget? newChild) {
    child = newChild;

    notifyListeners();
    _scaffoldKey?.currentState?.openEndDrawer();
  }
}
