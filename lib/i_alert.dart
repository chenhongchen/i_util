import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IAlert {
  /// text内容alert
  static Future<T?> text<T>(
    BuildContext context, {
    String? title,
    TextStyle? titleStyle,
    required String content,
    TextStyle? contentStyle,
    String? leftTitle,
    TextStyle? leftStyle,
    VoidCallback? onTapLeft,
    String? rightTitle,
    TextStyle? rightStyle,
    VoidCallback? onTapRight,
  }) {
    contentStyle ??= const TextStyle(fontSize: 14, color: Colors.black);
    return widget(
      context,
      title: title,
      titleStyle: titleStyle,
      content: Text(content, style: contentStyle),
      leftTitle: leftTitle,
      leftStyle: leftStyle,
      onTapLeft: onTapLeft,
      rightTitle: rightTitle,
      rightStyle: rightStyle,
      onTapRight: onTapRight,
    );
  }

  /// Widget内容alert
  static Future<T?> widget<T>(
    BuildContext context, {
    String? title,
    TextStyle? titleStyle,
    required Widget content,
    String? leftTitle,
    TextStyle? leftStyle,
    VoidCallback? onTapLeft,
    String? rightTitle,
    TextStyle? rightStyle,
    VoidCallback? onTapRight,
  }) {
    return showCupertinoDialog<T>(
      context: context,
      builder: (context) {
        title ??= '系统提示';
        titleStyle ??= const TextStyle(
            fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600);
        leftTitle ??= '取消';
        leftStyle ??= const TextStyle(
            fontSize: 18,
            color: Color(0xFF007AFF),
            fontWeight: FontWeight.w600);
        rightTitle ??= '确定';
        rightStyle ??= const TextStyle(fontSize: 18, color: Color(0xFF007AFF));
        return CupertinoAlertDialog(
          title: title == '' ? null : Text(title!, style: titleStyle),
          content: content,
          actions: [
            CupertinoDialogAction(
              textStyle: leftStyle,
              onPressed: () {
                Navigator.of(context).pop(0);
                onTapLeft?.call();
              },
              child: Text(leftTitle!),
            ),
            CupertinoDialogAction(
              textStyle: rightStyle,
              onPressed: () async {
                Navigator.of(context).pop(0);
                onTapRight?.call();
              },
              child: Text(rightTitle!),
            ),
          ],
        );
      },
    );
  }
}
