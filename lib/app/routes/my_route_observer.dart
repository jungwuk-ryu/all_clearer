import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MyRouteObserver extends GetObserver {
  Rxn<Route> rxRoute = Rxn();

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    rxRoute.value = route;
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    rxRoute.value = previousRoute;
  }

  void addListener(Function(Route? route) callback) {
    rxRoute.listen((p0) => callback(p0));
  }

}