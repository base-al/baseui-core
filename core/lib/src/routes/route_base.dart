// core/lib/src/routes/route_base.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseRoute {
  final String name;
  final Widget Function() page;
  final Bindings? binding;
  final CustomTransition? customTransition;
  final Transition? transition;
  final Curve curve;
  final bool? popGesture;
  final bool? fullscreenDialog;
  final bool opaque;
  final bool? maintainState;
  final Duration? transitionDuration;
  final String? title;
  final List<GetMiddleware>? middlewares;

  const BaseRoute({
    required this.name,
    required this.page,
    this.binding,
    this.customTransition,
    this.transition,
    this.curve = Curves.easeInOut,
    this.popGesture,
    this.fullscreenDialog = false,
    this.opaque = true,
    this.maintainState = true,
    this.transitionDuration,
    this.title,
    this.middlewares,
  });

  GetPage toGetPage() {
    return GetPage(
      name: name,
      page: page,
      binding: binding,
      transition: transition,
      curve: curve,
      popGesture: popGesture,
      fullscreenDialog: fullscreenDialog ?? false,
      opaque: opaque,
      maintainState: maintainState ?? true,
      transitionDuration: transitionDuration,
      title: title,
      middlewares: middlewares,
    );
  }

  GetPage toProtectedPage({
    List<GetMiddleware>? additionalMiddlewares,
    Widget Function(Widget)? wrapper,
  }) {
    return GetPage(
      name: name,
      page: () {
        final pageWidget = page();
        return wrapper != null ? wrapper(pageWidget) : pageWidget;
      },
      binding: binding,
      transition: transition,
      curve: curve,
      popGesture: popGesture,
      fullscreenDialog: fullscreenDialog ?? false,
      opaque: opaque,
      maintainState: maintainState ?? true,
      transitionDuration: transitionDuration,
      title: title,
      middlewares: [
        if (middlewares != null) ...middlewares!,
        if (additionalMiddlewares != null) ...additionalMiddlewares,
      ],
    );
  }
}

abstract class BaseRoutes {
  const BaseRoutes._();

  static List<GetPage> applyMiddleware(
    List<GetPage> routes,
    List<GetMiddleware> middlewares,
  ) {
    return routes.map((route) {
      return GetPage(
        name: route.name,
        page: route.page,
        binding: route.binding,
        middlewares: [
          ...(route.middlewares ?? []),
          ...middlewares,
        ],
        transition: route.transition,
        curve: route.curve,
        fullscreenDialog: route.fullscreenDialog,
        opaque: route.opaque,
        maintainState: route.maintainState,
        transitionDuration: route.transitionDuration,
        title: route.title,
      );
    }).toList();
  }
}
