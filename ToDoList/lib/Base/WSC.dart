import 'package:flutter/material.dart';

class ControllerHolder<C> {
  C? controller;

  bool get isEmpty => controller == null;
}

abstract class StatefulWidgetWithController<C extends StateController?>
    extends StatefulWidget {

  StatefulWidgetWithController({super.key});

  final ControllerHolder<C> _ch = ControllerHolder();

  @override
  State<StatefulWidget> createState() {
    var state = createStateWithController();

    // lazy initialize controller
    if (_ch.isEmpty) {
      _ch.controller = state.controller;
    } else {
      state._controller = _ch.controller!..attachState(state);
    }

    return state;
  }

  StateWithController<StatefulWidget, C> createStateWithController();
}

abstract class StateWithController<W extends StatefulWidget,
    C extends StateController?> extends State<W> {

  @protected
  C? _controller;

  C get controller {
    // controller is not null and state is attached
    if (_controller != null && _controller!._state != null) {
      return _controller!;
    }

    _controller ??= createController();

    if (_controller!._state == null) {
      _controller!.attachState(this);
    }

    return _controller!;
  }

  @override
  void initState() {
    super.initState();
    controller!._onInit();
  }

  @override
  void dispose() {
    controller!._onDispose();
    super.dispose();
  }

  C createController();
}

/// Inherit from StateController, and make api calls and other data accesses
/// from it. Use load / unload methods in order to initialize / dispose
/// containing controllers
class StateController<S, W> {
  bool isInitialized = false;

  // AppLocalizations get localizations => (_state as StateWithController).localizations;

  @protected
  BuildContext get context => _state!.context;

  @protected
  State? _state;

  void attachState(State state) {
    this._state = state;
  }

  @protected
  void setState(VoidCallback block) => _state?.setState(block);

  void notifyStateChanged() => _state?.setState(() {});

  void _onInit() {
    if (isInitialized) {
      load();
    } else {
      init();
      isInitialized = true;
      load();
    }
  }

  void _onDispose() {
    unload();
    _state = null;
  }

  void init() {}

  void load() {}

  void unload() {}

  S? get state => _state as S?;

  W get widget => _state?.widget as W;
}
