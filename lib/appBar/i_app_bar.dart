import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../i_size.dart';

const iAppBarIconDefWidth = 44.0;
const iAppBarDefHeight = kToolbarHeight;

class IAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool autoFitForegroundColor;
  final bool hasBackBtn;
  final Color? backBtnColor;
  final bool hasBotLine;
  final Color? botLineColor;
  final Widget? title;
  final bool titleInCenter;
  final List<Widget>? leftActions;
  final List<Widget>? rightActions;
  final Color backgroundColor;
  final Decoration? backgroundDecoration;
  final Image? backgroundImage;
  final GestureTapCallback? onTapBackBtn;
  final Widget? bottom;
  final double bottomH;
  final double barH;
  final EdgeInsetsGeometry? padding;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool forceMaterialTransparency;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;

  @override
  Size get preferredSize =>
      Size(ISize.screenW, ISize.statusBarH + barH + bottomH);

  const IAppBar({
    Key? key,
    this.hasBackBtn = true,
    this.backBtnColor,
    this.autoFitForegroundColor = true,
    this.hasBotLine = false,
    this.botLineColor,
    this.title,
    this.titleInCenter = true,
    this.backgroundColor = Colors.white,
    this.backgroundDecoration,
    this.backgroundImage,
    this.onTapBackBtn,
    this.leftActions,
    this.rightActions,
    this.bottom,
    this.barH = iAppBarDefHeight,
    this.bottomH = 0,
    this.padding,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IAppBar();
  }
}

class _IAppBar extends State<IAppBar> {
  SystemUiOverlayStyle _systemOverlayStyleForBrightness(Brightness brightness,
      [Color? backgroundColor]) {
    final SystemUiOverlayStyle style = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    // For backward compatibility, create an overlay style without system navigation bar settings.
    return SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
      statusBarBrightness: style.statusBarBrightness,
      statusBarIconBrightness: style.statusBarIconBrightness,
      systemStatusBarContrastEnforced: style.systemStatusBarContrastEnforced,
    );
  }

  final ValueNotifier<double> _titleWidth = ValueNotifier<double>(0);

  late final _leftKey = GlobalKey();
  late final _rightKey = GlobalKey();

  @override
  void dispose() {
    _titleWidth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final SystemUiOverlayStyle overlayStyle = widget.systemOverlayStyle ??
        appBarTheme.systemOverlayStyle ??
        _systemOverlayStyleForBrightness(
          ThemeData.estimateBrightnessForColor(widget.backgroundColor),
          theme.useMaterial3 ? const Color(0x00000000) : null,
        );
    return Semantics(
      container: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Material(
          elevation: 0,
          type: widget.forceMaterialTransparency
              ? MaterialType.transparency
              : MaterialType.canvas,
          shadowColor: widget.shadowColor ?? appBarTheme.shadowColor,
          surfaceTintColor:
              widget.surfaceTintColor ?? appBarTheme.surfaceTintColor,
          shape: widget.shape ?? appBarTheme.shape,
          child: Semantics(
            explicitChildNodes: true,
            child: _buildAppBar(context, overlayStyle),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, SystemUiOverlayStyle overlayStyle) {
    Color fitColor = (overlayStyle.statusBarBrightness == Brightness.dark
        ? Colors.white
        : Colors.black);
    Color? backgroundColor = widget.backgroundColor;
    if (widget.backgroundDecoration != null) {
      backgroundColor = null;
    }

    return Container(
      height: widget.preferredSize.height,
      width: MediaQuery.of(context).size.width,
      color: backgroundColor,
      decoration: widget.backgroundDecoration,
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: widget.preferredSize.height,
            child: widget.backgroundImage,
          ),
          Positioned.fill(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                widget.autoFitForegroundColor
                    ? ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          fitColor,
                          BlendMode.srcIn,
                        ),
                        child: _buildContent(fitColor),
                      )
                    : _buildContent(fitColor),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: widget.bottomH,
                  child: widget.bottom,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContent(Color fitColor) {
    Widget backBtn = widget.hasBackBtn
        ? GestureDetector(
            onTap: () {
              if (widget.onTapBackBtn != null) {
                widget.onTapBackBtn!();
              } else {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: Container(
              width: iAppBarIconDefWidth,
              height: widget.barH,
              color: Colors.transparent,
              child: Icon(
                Icons.arrow_back_ios_new,
                color: widget.backBtnColor ?? fitColor,
              ),
            ),
          )
        : Container();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widget.barH,
      padding: widget.padding,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Row(
              children: [
                Row(
                  key: _leftKey,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    backBtn,
                    if (widget.leftActions != null) ...widget.leftActions!,
                  ],
                ),
                widget.titleInCenter
                    ? Expanded(child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                        Future.microtask(() {
                          final RenderBox? leftRB = _leftKey.currentContext
                              ?.findRenderObject() as RenderBox?;
                          final leftW = leftRB?.size.width ?? 0;
                          final RenderBox? rightRB = _rightKey.currentContext
                              ?.findRenderObject() as RenderBox?;
                          final rightW = rightRB?.size.width ?? 0;
                          double width = MediaQuery.of(context).size.width -
                              max(leftW, rightW) * 2;
                          if (width > 0) _titleWidth.value = width;
                        });
                        return const SizedBox();
                      }))
                    : Expanded(child: Center(child: widget.title)),
                Row(
                  key: _rightKey,
                  children: [
                    if (widget.rightActions != null) ...widget.rightActions!,
                  ],
                ),
              ],
            ),
          ),
          if (widget.hasBotLine)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 0.5,
              child: Container(
                  height: 0.5,
                  color: widget.botLineColor ?? const Color(0xFFEEEEEE)),
            ),
          if (widget.titleInCenter)
            Align(
              alignment: Alignment.center,
              child: ValueListenableBuilder(
                  valueListenable: _titleWidth,
                  builder: (BuildContext context, double value, Widget? child) {
                    return Container(
                      alignment: Alignment.center,
                      width: value,
                      child: widget.title,
                    );
                  }),
            )
        ],
      ),
    );
  }
}
