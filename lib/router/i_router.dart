import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'net_status_manager.dart';

class IRouter {
  static VoidCallback? _willOpen;
  static VoidCallback? _didPop;
  static String _routePrefix = '';
  static String _rootPages = '';
  static Widget Function(Widget child)? _wrapperBuilder;

  /// routePrefix 路由名前缀
  /// rootPages 路由根页面类名，有多个的话用","分割
  /// willOpen 路由将打开时回调
  /// didPop 路由返回后回调
  /// wrapperBuilder widget包裹回调
  static void config(
    String routePrefix, {
    List rootPages = const [],
    VoidCallback? willOpen,
    VoidCallback? didPop,
    Widget Function(Widget child)? wrapperBuilder,
  }) {
    _routePrefix = routePrefix;
    _willOpen = willOpen;
    _didPop = didPop;
    _rootPages = rootPages.map((e) => _routeUrl(e)).join(',');
    _wrapperBuilder = wrapperBuilder;
  }

  /// push一个页面
  static Future<T?> open<T extends Object>(
    BuildContext context, {
    required Widget widget,
    bool fullscreenDialog = false,
    bool? opaque,
    Color? barrierColor,
    bool needNetConnected = false,
  }) {
    if (needNetConnected && NetStatusNotifier().isConnected == false) {
      NetStatusNotifier().showNetExceptionToast();
      return Future.value();
    }
    _willOpen?.call();
    Future<T?> result = Navigator.of(context, rootNavigator: true)
        .push<T>(NewCupertinoPageRoute(
            fullscreenDialog: fullscreenDialog,
            opaque: opaque,
            barrierColor: barrierColor,
            settings: RouteSettings(name: _routeUrl(widget)),
            builder: (BuildContext context) {
              return _buildChild(widget);
            }))
        .then((value) {
      _didPop?.call();
      return value;
    });
    return result;
  }

  /// push一个页面，过度动画为淡入淡出
  static Future<T?> openFade<T extends Object>(
    BuildContext context, {
    required Widget widget,
    ExitAnimation exitAnimation = ExitAnimation.normal,
    bool needNetConnected = false,
  }) {
    if (needNetConnected && NetStatusNotifier().isConnected == false) {
      NetStatusNotifier().showNetExceptionToast();
      return Future.value();
    }
    _willOpen?.call();
    Future<T?> result = Navigator.of(context, rootNavigator: true)
        .push<T>(ReplacementRoute(
            exitAnimation: exitAnimation,
            settings: RouteSettings(name: _routeUrl(widget)),
            builder: (BuildContext context) {
              return _buildChild(widget);
            }))
        .then((value) {
      _didPop?.call();
      return value;
    });
    return result;
  }

  /// 替换方式push一个页面，
  static Future<T?> openReplacement<T extends Object?, T0 extends Object?>(
    BuildContext context, {
    required Widget widget,
    ExitAnimation exitAnimation = ExitAnimation.normal,
    bool fullscreenDialog = false,
    bool needNetConnected = false,
  }) {
    if (needNetConnected && NetStatusNotifier().isConnected == false) {
      NetStatusNotifier().showNetExceptionToast();
      return Future.value();
    }
    _willOpen?.call();
    Future<T?> result = Navigator.of(context, rootNavigator: true)
        .pushReplacement<T, T0>(ReplacementRoute(
            exitAnimation: exitAnimation,
            fullscreenDialog: fullscreenDialog,
            settings: RouteSettings(name: _routeUrl(widget)),
            builder: (BuildContext context) {
              return _buildChild(widget);
            }))
        .then((value) {
      _didPop?.call();
      return value;
    });
    return result;
  }

  /// pop到上一个页面
  static void close<T extends Object?>(BuildContext context, [T? result]) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop<T>(result);
    }
  }

  /// pop到指定类页面
  static closeUntil(
    BuildContext context,
    var className, {
    bool animated = true,
  }) {
    Navigator.of(context).popUntil((route) {
      bool routeOk = (route.settings.name == _routeUrl(className) ||
          route.settings.name == '/' ||
          (route.settings.name != null &&
              _rootPages.contains(route.settings.name!)));
      return routeOk;
    });
  }

  /// pop到指定类页面的上一个页面
  static closeUntilLast(
    BuildContext context,
    var className, {
    bool animated = true,
  }) {
    bool isLast = false;
    Navigator.of(context).popUntil((route) {
      if (route.settings.name == '/' ||
          (route.settings.name != null &&
              _rootPages.contains(route.settings.name!)) ||
          isLast) {
        return true;
      }
      if (route.settings.name == _routeUrl(className)) {
        isLast = true;
      }
      return false;
    });
  }

  /// pop到根页面
  static void closeToFoot<T extends Object?>(BuildContext context) {
    // 1. 移除除根路由以外的所其他路由，并push一个没有转场动画的透明页面，
    // 2. 然后关闭刚push透明页面，这时pop就不会有转场动画
    var build = PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => Container(color: Colors.transparent),
      transitionDuration: const Duration(seconds: 0),
      opaque: false,
      barrierColor: Colors.transparent,
    );
    Navigator.of(context).pushAndRemoveUntil<T>(build, (route) {
      if (route.settings.name == '/' ||
          (route.settings.name != null &&
              _rootPages.contains(route.settings.name!))) {
        return true;
      }
      return false;
    });
    close<T>(context);
  }

  static String _routeUrl(var className) {
    return '${_routePrefix}_$className';
  }

  static Widget _buildChild(Widget child) {
    if (_wrapperBuilder == null) {
      return child;
    } else {
      return _wrapperBuilder!.call(child);
    }
  }
}

enum ExitAnimation {
  none,
  normal,
  fade,
}

class ReplacementRoute<T> extends PageRoute<T> {
  ReplacementRoute({
    this.barrierColor,
    this.barrierLabel,
    required this.builder,
    this.opaque = true,
    this.barrierDismissible = false,
    this.maintainState = true,
    RouteSettings? settings,
    this.exitAnimation = ExitAnimation.normal,
    bool fullscreenDialog = false,
  })  : transitionDuration =
            Duration(milliseconds: fullscreenDialog ? 250 : 300),
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder builder;
  final ExitAnimation exitAnimation;

  @override
  final Duration transitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  @override
  final bool maintainState;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      builder(context);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    //当前路由被激活，是打开新路由
    if (isActive) {
      //进入动画（渐变过渡动画）
      return FadeTransition(
        // 透明度从 0.0-1.0
        opacity: Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        child: child,
      );
    }
    //退出动画
    else {
      if (exitAnimation == ExitAnimation.normal) {
        Offset beginOffset = const Offset(1.0, 0.0);
        if (fullscreenDialog) {
          beginOffset = const Offset(0.0, 1.0);
        }
        return SlideTransition(
            position:
                Tween<Offset>(begin: beginOffset, end: const Offset(0.0, 0.0))
                    .animate(CurvedAnimation(
              parent: animation,
              curve: Curves.ease,
            )),
            child: child);
      } else {
        double begin = 1.0;
        if (exitAnimation == ExitAnimation.none) {
          begin = 0.0;
        }
        //进入动画（渐变过渡动画）
        return FadeTransition(
          // 透明度从 0.0-1.0
          opacity: Tween(begin: begin, end: 0.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        );
      }
    }
  }
}

class NewCupertinoPageRoute<T> extends PageRoute<T>
    with CupertinoRouteTransitionMixin<T> {
  /// Creates a page route for use in an iOS designed app.
  ///
  /// The [builder], [maintainState], and [fullscreenDialog] arguments must not
  /// be null.
  NewCupertinoPageRoute({
    required this.builder,
    this.title,
    super.settings,
    this.maintainState = true,
    super.fullscreenDialog,
    super.allowSnapshotting = true,
    Color? barrierColor,
    bool? opaque,
  })  : _barrierColor = barrierColor,
        _opaque = opaque;

  final Color? _barrierColor;
  final bool? _opaque;

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  @override
  Widget buildContent(BuildContext context) => builder(context);

  @override
  final String? title;

  @override
  final bool maintainState;

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';

  @override
  bool get opaque => _opaque ?? super.opaque;

  @override
  Color? get barrierColor => _barrierColor ?? super.barrierColor;
}
