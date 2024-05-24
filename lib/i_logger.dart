import 'dart:convert';

import 'package:flutter/foundation.dart';

class ILogger {
  static const _separator = '=';
  static const _split =
      '$_separator$_separator$_separator$_separator$_separator$_separator$_separator$_separator$_separator';
  static var _title = 'ILogger';
  static int _limitBytesLength = 1000;
  static String _startLine = '$_split$_title$_split';
  static String _endLine = '$_split$_separator$_separator$_separator$_split';
  static bool _format = false;

  static void init({String? title, int? limitLength, bool? format}) {
    _title = title ?? _title;
    _limitBytesLength = limitLength ?? _limitBytesLength;
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
    segmentationLog(msg);
    if (_format) {
      _logEmptyLine();
      _print(_endLine);
    }
  }

  static void segmentationLog(String msg) {
    List list = splitStringByByteSize(msg, _limitBytesLength);
    for (String str in list) {
      _print(str);
    }
  }

  /// 按限定的字节长度分割字符串
  static List<String> splitStringByByteSize(String str, int size) {
    List<int> encodedBytes = utf8.encode(str);
    List<String> result = [];
    int start = 0;

    while (start < encodedBytes.length) {
      int end = (start + size < encodedBytes.length)
          ? start + size
          : encodedBytes.length;

      // 确保不在一个字符的中间进行分割
      while (end < encodedBytes.length && (encodedBytes[end] & 0xC0) == 0x80) {
        end--;
      }

      List<int> byteSegment = encodedBytes.sublist(start, end);
      result.add(utf8.decode(byteSegment));
      start = end;
    }

    return result;
  }

  static void _logEmptyLine() {
    _print('');
  }

  static const void Function(Object object) _print = print;
}
