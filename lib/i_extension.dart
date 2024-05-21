import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:crypto/crypto.dart';
import "package:intl/intl.dart";
import '/value_util.dart';

extension IStringExt on String {
  /// 将每个字符串之间插入零宽空格,解决长字母、数字串整体显示省略问题
  String get toBreakWord {
    if (isEmpty) {
      return this;
    }
    String breakWord = ' ';
    for (var element in runes) {
      breakWord += String.fromCharCode(element);
      breakWord += '\u200B';
    }
    return breakWord;
  }

  /// 转成md5
  String get toMd5 {
    var content = const Utf8Encoder().convert(this);
    var digest = md5.convert(content);
    return digest.toString();
  }

  /// 字符串中的多空格转单空格
  String get toSingleSpaces {
    List<String> list = split('  ');
    String content = '';
    for (String item in list) {
      content = '$content${item.trim()} ';
    }
    return content.trimLeft();
  }

  /// 加后缀（file.jpg转成file+postfix+.+jpg，file转成file+postfix）
  String addPostfix(String postfix) {
    List list = split('.');
    if (list.isEmpty || list.length > 2) {
      return this;
    }
    if (list.length == 1) {
      return list.first + postfix;
    } else {
      return list.first + postfix + '.' + list.last;
    }
  }

  /// 比较版本大小，版本格式1.0.0
  /// 返回 1:A>B; 0:A==B; -1:A<B
  int compareVersion(String verB) {
    int verAInt, verBInt;
    var verAList = split('.');
    var verBList = verB.split('.');
    for (int i = 0; i < max(verAList.length, verBList.length); i++) {
      verAInt = i < verAList.length ? ValueUtil.toInt(verAList[i]) : 0;
      verBInt = i < verBList.length ? ValueUtil.toInt(verBList[i]) : 0;
      if (verAInt > verBInt) {
        return 1;
      } else if (verAInt < verBInt) {
        return -1;
      }
    }
    return 0;
  }
}

extension IIntExt on int {
  /// 秒时间戳转年龄
  String get toAge => DateTime.fromMillisecondsSinceEpoch(this * 1000).toAge;
}

extension IDateTimeExt on DateTime {
  /// 转年龄
  String get toAge {
    int age = 0;
    DateTime dateTime = DateTime.now();
    if (dateTime.isBefore(this)) {
      //出生日期晚于当前时间，无法计算
      return '出生日期不正確';
    }
    int yearNow = dateTime.year; //当前年份
    int monthNow = dateTime.month; //当前月份
    int dayOfMonthNow = dateTime.day; //当前日期

    int yearBirth = year;
    int monthBirth = month;
    int dayOfMonthBirth = day;
    age = yearNow - yearBirth; //计算整岁数
    if (monthNow <= monthBirth) {
      if (monthNow == monthBirth) {
        if (dayOfMonthNow < dayOfMonthBirth) age--; //当前日期在生日之前，年龄减一
      } else {
        age--; //当前月份在生日之前，年龄减一
      }
    }
    return age.toString();
  }
}

extension IDoubleExt on double {
  /// 人民币
  String get toRMB => toMoney(locale: 'zh_CN', symbol: '￥');

  /// 美元
  String get toUSD => toMoney(locale: 'en_US', symbol: '\$');

  String toMoney({
    String? locale,
    String? name,
    String? symbol,
    int decimalDigits = 2,
    String? customPattern,
    bool trimTrailZero = true,
  }) {
    final formatCurrency = NumberFormat.currency(
      locale: locale,
      name: name,
      symbol: symbol,
      decimalDigits: decimalDigits,
      customPattern: customPattern,
    );
    String text = formatCurrency.format(this);

    // 尾部是0处理
    if (trimTrailZero) {
      for (int i = 0; i < decimalDigits; i++) {
        String lastChar = text.substring(text.length - 1);
        if (lastChar == '0') {
          text = text.substring(0, text.length - (i + 1));
        } else {
          return text;
        }
      }
    }
    return text;
  }
}

extension IColorExt on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  /// 转成图片
  Future<Uint8List?> toImage({int width = 1, int height = 1}) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawRect(
      Rect.fromLTRB(0, 0, width.toDouble(), height.toDouble()),
      Paint()..color = this,
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);

    final byteData = await image.toByteData(format: ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  }
}
