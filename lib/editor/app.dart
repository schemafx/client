import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/drawer_state.dart';
import './pages/properties.dart';
import './pages/action_bar.dart';
import './pages/design.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DrawerStateModel()..setScaffoldKey(_scaffoldKey),
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: Consumer<DrawerStateModel>(
            builder: (context, model, child) => model.child ?? Container(),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              left: 10,
              bottom: 0,
              width: 330,
              height: 600,
              child: DesignScreen(),
            ),
            Positioned(right: 10, top: 10, child: ActionBar()),
            Positioned(
              bottom: 0,
              right: 10,
              height: 500,
              width: 300,
              child: PropertiesPanel(),
            ),
          ],
        ),
      ),
    );
  }
}
