import 'package:flutter/cupertino.dart';

class ISize {
  static double get screenW => ISize()._screenW;

  static double get screenH => ISize()._screenH;

  static double get statusBarH => ISize()._statusBarH;

  static double get safeBottomH => ISize()._safeBottomH;

  static double get devicePixelRatio => ISize()._devicePixelRatio;

  static double get textScaleFactor => ISize()._textScaleFactor;

  // 工厂模式
  factory ISize() => _getInstance();

  static ISize get instance => _getInstance();
  static ISize? _instance;

  ISize._internal() {
    // 初始化
    _init();
  }

  static ISize _getInstance() {
    _instance ??= ISize._internal();
    return _instance!;
  }

  late final double _screenW;
  late final double _screenH;
  late final double _statusBarH;
  late final double _safeBottomH;
  late final double _devicePixelRatio;
  late final double _textScaleFactor;

  void _init() {
    var window = WidgetsBinding.instance.platformDispatcher.views.first;
    _devicePixelRatio = window.devicePixelRatio;
    _textScaleFactor =
        WidgetsBinding.instance.platformDispatcher.textScaleFactor;
    _screenW = window.physicalSize.width / devicePixelRatio;
    _screenH = window.physicalSize.height / devicePixelRatio;
    _statusBarH = window.padding.top / devicePixelRatio;
    _safeBottomH = window.padding.bottom / devicePixelRatio;
  }
}
