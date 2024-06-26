import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'i_app_bar.dart';

class IAction {
  Widget? widget;
  Widget? icon;
  String? text;
  TextStyle? style;
  VoidCallback? onTap;

  Widget get action {
    if (widget != null) {
      return GestureDetector(onTap: onTap, child: widget);
    } else if (icon != null) {
      return IAppBarUtil.iconItem(icon: icon!, onTap: onTap);
    } else if (text != null) {
      return IAppBarUtil.textItem(text: text!, style: style, onTap: onTap);
    } else {
      return const SizedBox();
    }
  }

  IAction({this.widget, this.icon, this.text, this.style, this.onTap});
}

class IAppBarUtil {
  static config({
    TextStyle? textTitleStyle,
    TextStyle? textItemStyle,
    Color? defBackgroundColor,
  }) {
    _textTitleStyle = textTitleStyle;
    _textItemStyle = textItemStyle;
    _defBackgroundColor = defBackgroundColor;
  }

  static TextStyle? _textTitleStyle;
  static TextStyle? _textItemStyle;
  static Color? _defBackgroundColor;

  static titleBar({
    Key? key,
    String text = '',
    Widget? widget,
    bool hasBackBtn = true,
    Color? backBtnColor,
    bool autoFitForegroundColor = true,
    bool hasBotLine = false,
    Color? botLineColor,
    bool titleInCenter = true,
    Color? backgroundColor,
    Decoration? backgroundDecoration,
    Image? backgroundImage,
    VoidCallback? onTapBackBtn,
    List<IAction>? leftActions,
    List<IAction>? rightActions,
    Widget? bottom,
    double bottomH = 0,
    double barH = iAppBarDefHeight,
    EdgeInsets padding = const EdgeInsets.only(left: 6, right: 6),
    SystemUiOverlayStyle? systemOverlayStyle,
    bool forceMaterialTransparency = false,
    Color? shadowColor,
    Color? surfaceTintColor,
    ShapeBorder? shape,
  }) {
    return IAppBar(
      key: key,
      title: widget ?? textTitle(text),
      hasBackBtn: hasBackBtn,
      backBtnColor: backBtnColor,
      autoFitForegroundColor: autoFitForegroundColor,
      hasBotLine: hasBotLine,
      botLineColor: botLineColor,
      titleInCenter: titleInCenter,
      backgroundColor: backgroundColor ?? _defBackgroundColor ?? Colors.white,
      backgroundDecoration: backgroundDecoration,
      backgroundImage: backgroundImage,
      onTapBackBtn: onTapBackBtn,
      leftActions: leftActions?.map((e) => e.action).toList(),
      rightActions: rightActions?.map((e) => e.action).toList(),
      bottom: bottom,
      bottomH: bottomH,
      barH: barH,
      padding: padding,
      systemOverlayStyle: systemOverlayStyle,
      forceMaterialTransparency: forceMaterialTransparency,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
    );
  }

  static textTitleBar({
    Key? key,
    String text = '',
    bool hasBackBtn = true,
    Color? backBtnColor,
    bool autoFitForegroundColor = true,
    bool hasBotLine = false,
    Color? botLineColor,
    bool titleInCenter = true,
    Color? backgroundColor,
    Decoration? backgroundDecoration,
    Image? backgroundImage,
    VoidCallback? onTapBackBtn,
    List<IAction>? leftActions,
    List<IAction>? rightActions,
    Widget? bottom,
    double bottomH = 0,
    double barH = iAppBarDefHeight,
    EdgeInsets padding = const EdgeInsets.only(left: 6, right: 6),
    SystemUiOverlayStyle? systemOverlayStyle,
    bool forceMaterialTransparency = false,
    Color? shadowColor,
    Color? surfaceTintColor,
    ShapeBorder? shape,
  }) {
    return titleBar(
      key: key,
      text: text,
      hasBackBtn: hasBackBtn,
      backBtnColor: backBtnColor,
      autoFitForegroundColor: autoFitForegroundColor,
      hasBotLine: hasBotLine,
      botLineColor: botLineColor,
      titleInCenter: titleInCenter,
      backgroundColor: backgroundColor,
      backgroundDecoration: backgroundDecoration,
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

  static Widget textItem({
    required String text,
    TextStyle? style,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: iAppBarDefHeight,
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Text(
          text,
          style: style ??
              _textItemStyle ??
              const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ),
    );
  }
}
