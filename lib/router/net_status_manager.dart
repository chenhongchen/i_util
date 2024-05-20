import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NetStatusNotifier extends ChangeNotifier {
  factory NetStatusNotifier() => _getInstance();

  static NetStatusNotifier get instance => _getInstance();
  static NetStatusNotifier? _instance;

  NetStatusNotifier._internal() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (status != result) {
        if (status != null && result == ConnectivityResult.none) {
          showNetExceptionToast();
        }
        status = result;
        if (!_disposed) {
          notifyListeners();
        }
      }
    });
  }

  static NetStatusNotifier _getInstance() {
    _instance ??= NetStatusNotifier._internal();
    return _instance!;
  }

  StreamSubscription? subscription;
  ConnectivityResult? status;

  bool _isConnected = true;

  bool get isConnected => status != ConnectivityResult.none && _isConnected;

  bool _disposed = false;

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    subscription?.cancel();
    super.dispose();
  }

  showNetExceptionToast() {
    Fluttertoast.showToast(
      msg: '网络好像有点问题',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: const Color(0xBF000000),
      textColor: const Color(0xFFFFFFFF).withOpacity(0.88),
      fontSize: 16.0,
    );
  }

  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _isConnected = true;
      }
    } on SocketException catch (_) {
      _isConnected = false;
    }
  }
}
