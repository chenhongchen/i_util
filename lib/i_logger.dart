import 'package:flutter/foundation.dart';

class ILogger {
  static const _separator = '=';
  static const _split =
      '$_separator$_separator$_separator$_separator$_separator$_separator$_separator$_separator$_separator';
  static var _title = 'ILogger';
  static int _limitLength = 800;
  static String _startLine = '$_split$_title$_split';
  static String _endLine = '$_split$_separator$_separator$_separator$_split';
  static bool _format = false;

  static void init({String? title, int? limitLength, bool? format}) {
    _title = title ?? _title;
    _limitLength = limitLength ?? _limitLength;
    _format = format ?? _format;
    _startLine = '$_split$_title$_split';
    var endLineStr = StringBuffer();
    var cnCharReg = RegExp('[\u4e00-\u9fa5]');
    for (int i = 0; i < _startLine.length; i++) {
      if (cnCharReg.stringMatch(_startLine[i]) != null) {
        endLineStr.write(_separator);
      }
      endLineStr.write(_separator);
    }
    _endLine = endLineStr.toString();
  }

  /// 仅仅debug环境打印
  static void d(dynamic obj) {
    _log(obj.toString(), true);
  }

  /// 所有环境打印
  static void v(dynamic obj) {
    _log(obj.toString(), false);
  }

  static void _log(String msg, bool onlyDebug) {
    if (onlyDebug && !kDebugMode) return;
    if (_format) {
      _print(_startLine);
      _logEmptyLine();
    }
    if (msg.length < _limitLength) {
      _print(msg);
    } else {
      segmentationLog(msg);
    }
    if (_format) {
      _logEmptyLine();
      _print(_endLine);
    }
  }

  static void segmentationLog(String msg) {
    var outStr = StringBuffer();
    for (var index = 0; index < msg.length; index++) {
      outStr.write(msg[index]);
      if (index % _limitLength == 0 && index != 0) {
        _print(outStr);
        outStr.clear();
        var lastIndex = index + 1;
        if (msg.length - lastIndex < _limitLength) {
          var remainderStr = msg.substring(lastIndex, msg.length);
          _print(remainderStr);
          break;
        }
      }
    }
  }

  static void _logEmptyLine() {
    _print('');
  }

  static const void Function(Object object) _print = print;
}
