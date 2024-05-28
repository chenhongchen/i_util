import 'package:flutter/cupertino.dart';

class ISize {
  static bool get isEmpty => ISize()._isEmpty;

  static double get screenW => ISize()._screenW;

  static double get screenH => ISize()._screenH;

  static double get statusBarH => ISize()._statusBarH;

  static double get safeBottomH => ISize()._safeBottomH;

  static double get devicePixelRatio => ISize()._devicePixelRatio;

  static double get textScaleFactor => ISize()._textScaleFactor;

  static void init(BuildContext context) {
    if (_instance == null || _instance!._isEmpty) {
      ISize(context: context);
    }
  }

  static String get string => ISize().toString();

  // 工厂模式
  factory ISize({BuildContext? context}) => _getInstance(context: context);

  static ISize get instance => _getInstance();
  static ISize? _instance;

  ISize._internal({BuildContext? context}) {
    // 初始化
    _init(context: context);
  }

  static ISize _getInstance({BuildContext? context}) {
    if (_instance != null) return _instance!;
    var iSize = ISize._internal(context: context);
    if (iSize._isEmpty) return iSize;
    _instance = iSize;
    return _instance!;
  }

  bool get _isEmpty => _screenW == 0 || _screenH == 0;
  late final double _screenW;
  late final double _screenH;
  late final double _statusBarH;
  late final double _safeBottomH;
  late final double _devicePixelRatio;
  late final double _textScaleFactor;

  void _init({BuildContext? context}) {
    if (context != null) {
      _devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
      _textScaleFactor = MediaQuery.of(context).textScaleFactor;
      _screenW = MediaQuery.of(context).size.width;
      _screenH = MediaQuery.of(context).size.height;
      _statusBarH = MediaQuery.of(context).padding.top;
      _safeBottomH = MediaQuery.of(context).padding.bottom;
      return;
    }
    var window = WidgetsBinding.instance.platformDispatcher.views.first;
    _devicePixelRatio = window.devicePixelRatio;
    _textScaleFactor =
        WidgetsBinding.instance.platformDispatcher.textScaleFactor;
    _screenW = window.physicalSize.width / _devicePixelRatio;
    _screenH = window.physicalSize.height / _devicePixelRatio;
    _statusBarH = window.padding.top / _devicePixelRatio;
    _safeBottomH = window.padding.bottom / _devicePixelRatio;
  }

  @override
  String toString() {
    return 'ISize::screenW:$_screenW,screenH:$_screenH,statusBarH:$_statusBarH,safeBottomH:$_safeBottomH,devicePixelRatio:$_devicePixelRatio,textScaleFactor:$_textScaleFactor';
  }
}
