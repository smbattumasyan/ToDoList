import 'package:flutter/material.dart';

class SlideRoute extends PageRouteBuilder {
  final widget;

  SlideRoute(this.widget,
      {Duration duration = const Duration(milliseconds: 200)})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                widget,
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                SlideTransition(
                  position: Tween(begin: Offset(0.8, 0.0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: animation,
                          reverseCurve: Curves.fastOutSlowIn,
                          curve: Curves.decelerate)),
                  child: FadeTransition(
                    child: child,
                    opacity: CurvedAnimation(
                        parent: animation,
                        reverseCurve: Curves.easeOut,
                        curve: Curves.easeIn),
                  ),
                ),
            transitionDuration: duration);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // fTODO: implement buildPage
    return super.buildPage(context, animation, secondaryAnimation);
  }
}

class EnterExitRoute extends PageRouteBuilder {
  final Widget? enterPage;
  final Widget? exitPage;
  EnterExitRoute({this.exitPage, this.enterPage})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    enterPage!,
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        Stack(
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.0),
                end: const Offset(-1.0, 0.0),
              ).animate(animation),
              child: exitPage,
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: enterPage,
            )
          ],
        ),
  );
}

class ScrollRoute extends PageRouteBuilder {
  final widget;

  ScrollRoute(this.widget,
      {Duration duration = const Duration(milliseconds: 200)})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      widget,
      transitionsBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) =>
          SlideTransition(
            position: Tween(begin: Offset(0.8, 0.0), end: Offset.zero)
                .animate(CurvedAnimation(
                parent: animation,
                reverseCurve: Curves.fastOutSlowIn,
                curve: Curves.decelerate)),
            child: child,
          ),
      transitionDuration: duration);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // fTODO: implement buildPage
    return super.buildPage(context, animation, secondaryAnimation);
  }
}

class FadeRoute extends PageRouteBuilder {
  final widget;

  FadeRoute(this.widget,
      {Duration duration = const Duration(milliseconds: 200)})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                widget,
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
                  child: widget,
                  opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: animation,
                      reverseCurve: Curves.fastOutSlowIn,
                      curve: Curves.decelerate)),
                ),
            transitionDuration: duration);
}

class AppPopupRoute<T> extends PopupRoute<T> {
  final Widget widget;

  AppPopupRoute(this.widget);

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return widget;
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);
}
