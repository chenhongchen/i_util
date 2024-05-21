class ValueUtil {
  static int toInt(dynamic value, {int defaultValue = 0}) {
    if (value is String) {
      if (value.isNotEmpty) {
        return int.parse(value);
      } else {
        return defaultValue;
      }
    } else if (value is num) {
      return value.toInt();
    } else if (value is bool) {
      if (value == true) {
        return 1;
      } else {
        return 0;
      }
    } else {
      return defaultValue;
    }
  }

  static double toDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value is String) {
      if (value.isNotEmpty) {
        return double.parse(value);
      } else {
        return defaultValue;
      }
    } else if (value is num) {
      return value.toDouble();
    } else if (value is bool) {
      if (value == true) {
        return 1.0;
      } else {
        return 0.0;
      }
    } else {
      return defaultValue;
    }
  }

  static String toStr(dynamic value, {String def = ''}) {
    if (value is String) {
      return value;
    } else if (value is num) {
      return value.toString();
    } else if (value is bool) {
      if (value == true) {
        return '1';
      } else {
        return '0';
      }
    } else {
      return def;
    }
  }

  static List toArr(dynamic value) {
    if (value is List) {
      return value;
    } else {
      return [];
    }
  }

  static Map toMap(dynamic value) {
    if (value is Map) {
      return value;
    } else {
      return {};
    }
  }

  static num toNum(dynamic value) {
    if (value is num) {
      return value;
    } else if (value is String) {
      if (value.contains('.')) {
        return double.parse(value);
      } else {
        return int.parse(value);
      }
    } else if (value is bool) {
      if (value == true) {
        return 1;
      } else {
        return 0;
      }
    } else {
      return -666;
    }
  }

  static bool toBool(dynamic value) {
    if (value is bool) {
      return value;
    } else if (value is String) {
      return value == 'true' || value == '1';
    } else {
      int intValue = ValueUtil.toInt(value);
      return intValue != 0;
    }
  }

  static Map toStringKeyMap(dynamic value) {
    Map map = toMap(value);
    Map<String, dynamic> stringKeyMap = <String, dynamic>{};
    List keys = map.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      var key = keys[i];
      if (key == null) {
        continue;
      }
      var value = map[key];
      if (value is Map) {
        stringKeyMap[toStr(key)] = toStringKeyMap(value);
      } else if (value is List) {
        List tempList = [];
        for (var item in value) {
          if (item is Map) {
            tempList.add(toStringKeyMap(item));
          } else {
            tempList.add(item);
          }
        }
        stringKeyMap[toStr(key)] = tempList;
      } else {
        stringKeyMap[toStr(key)] = value;
      }
    }
    return stringKeyMap;
  }
}
