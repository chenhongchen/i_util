import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'i_app_bar.dart';

class AppBarUtil {
  static config({
    TextStyle? textTitleStyle,
    TextStyle? textItemStyle,
  }) {
    _textTitleStyle = textTitleStyle;
    _textItemStyle = textItemStyle;
  }

  static TextStyle? _textTitleStyle;
  static TextStyle? _textItemStyle;

  static titleBar(
    BuildContext context, {
    Key? key,
    String text = '',
    Widget? widget,
    bool hasBackBtn = true,
    Color? backBtnColor,
    bool autoFitForegroundColor = true,
    bool hasBotLine = false,
    Color? botLineColor,
    bool titleInCenter = true,
    Color backgroundColor = Colors.white,
    Image? backgroundImage,
    VoidCallback? onTapBackBtn,
    List<Widget>? leftActions,
    List<Widget>? rightActions,
    Widget? bottom,
    double bottomH = 0,
    EdgeInsets padding = const EdgeInsets.only(left: 6, right: 6),
    SystemUiOverlayStyle? systemOverlayStyle,
    bool forceMaterialTransparency = false,
    Color? shadowColor,
    Color? surfaceTintColor,
    ShapeBorder? shape,
  }) {
    return IAppBar(
      context,
      key: key,
      title: widget ?? textTitle(text),
      hasBackBtn: hasBackBtn,
      backBtnColor: backBtnColor,
      autoFitForegroundColor: autoFitForegroundColor,
      hasBotLine: hasBotLine,
      botLineColor: botLineColor,
      titleInCenter: titleInCenter,
      backgroundColor: backgroundColor,
      backgroundImage: backgroundImage,
      onTapBackBtn: onTapBackBtn,
      leftActions: leftActions,
      rightActions: rightActions,
      bottom: bottom,
      bottomH: bottomH,
      padding: padding,
      systemOverlayStyle: systemOverlayStyle,
      forceMaterialTransparency: forceMaterialTransparency,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
    );
  }

  static textTitleBar(
    BuildContext context, {
    Key? key,
    String text = '',
    bool hasBackBtn = true,
    Color? backBtnColor,
    bool autoFitForegroundColor = true,
    bool hasBotLine = false,
    Color? botLineColor,
    bool titleInCenter = true,
    Color backgroundColor = Colors.white,
    Image? backgroundImage,
    VoidCallback? onTapBackBtn,
    List<Widget>? leftActions,
    List<Widget>? rightActions,
    Widget? bottom,
    double bottomH = 0,
    EdgeInsets padding = const EdgeInsets.only(left: 6, right: 6),
    SystemUiOverlayStyle? systemOverlayStyle,
    bool forceMaterialTransparency = false,
    Color? shadowColor,
    Color? surfaceTintColor,
    ShapeBorder? shape,
  }) {
    return titleBar(
      context,
      key: key,
      text: text,
      hasBackBtn: hasBackBtn,
      backBtnColor: backBtnColor,
      autoFitForegroundColor: autoFitForegroundColor,
      hasBotLine: hasBotLine,
      botLineColor: botLineColor,
      titleInCenter: titleInCenter,
      backgroundColor: backgroundColor,
      backgroundImage: backgroundImage,
      onTapBackBtn: onTapBackBtn,
      leftActions: leftActions,
      rightActions: rightActions,
      bottom: bottom,
      bottomH: bottomH,
      padding: padding,
      systemOverlayStyle: systemOverlayStyle,
      forceMaterialTransparency: forceMaterialTransparency,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
    );
  }

  static Widget textTitle(String text) {
    return Text(
      text,
      style: _textTitleStyle ??
          const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  static Widget iconItem({required Widget icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: iAppBarIconDefWidth,
        height: iAppBarDefHeight,
        color: Colors.transparent,
        child: icon,
      ),
    );
  }

  static Widget textItem({required String text, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: iAppBarDefHeight,
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Text(
          text,
          style: _textItemStyle ??
              const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}
