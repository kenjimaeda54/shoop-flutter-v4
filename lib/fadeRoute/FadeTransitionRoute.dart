import 'package:flutter/material.dart';

class FadeTransitionRoute extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context,
      Animation<double> animation, Animation<double> secondaryAnimation,
      Widget child) {
    //como cancelar animação rota especifica
    if (route.settings.name == "/") {
      return child;
    }
    return FadeTransition(opacity: animation, child: child);
  }

}
