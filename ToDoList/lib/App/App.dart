import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'environments/Environment.dart';

class App extends StatefulWidget {
  static late Environment environment;
  static RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  const App({super.key});

  static _AppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  VoidCallback? onKeyboardHide;

  void updateState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Container();
  }
}