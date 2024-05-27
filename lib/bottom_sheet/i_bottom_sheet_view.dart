import 'package:flutter/material.dart';
import 'i_bottom_sheet.dart';

typedef TapBottomSheetItemCallback = void Function(IBottomSheetItem sheetItem);

Future<T?> showIBottomSheet<T>({
  Key? key,
  required BuildContext context,
  required List<IBottomSheetItem> sheetItems,
  Color bgColor = Colors.black54,
  TapBottomSheetItemCallback? onTap,
}) {
  return showIModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return BottomSheetView(key: key, sheetItems: sheetItems, onTap: onTap);
    },
    backgroundColor: bgColor,
    barrierColor: bgColor,
  );
}

class IBottomSheetItem {
  String text;
  TextStyle? style;
  Color backColor;
  Color? dividerColor;
  double height;

  IBottomSheetItem({
    this.text = '',
    this.style,
    this.backColor = Colors.white,
    this.dividerColor,
    this.height = 58.0,
  }) {
    style ??= const TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 16,
      color: Color(0xFF444444),
      decoration: TextDecoration.none,
    );
    dividerColor ??= const Color(0xFFEBEBEB);
  }
}

class BottomSheetView extends StatelessWidget {
  final List<IBottomSheetItem> sheetItems;
  final TapBottomSheetItemCallback? onTap;

  const BottomSheetView({super.key, required this.sheetItems, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: _getTotalHeight(),
        child: Column(children: _buildSheet(context)));
  }

  List<Widget> _buildSheet(BuildContext context) {
    var sheetViews = <Widget>[];
    for (IBottomSheetItem sheetItem in sheetItems) {
      var view = GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: sheetItem.height,
              color: sheetItem.backColor,
              child: Center(
                child: Text(
                  sheetItem.text,
                  style: sheetItem.style,
                ),
              ),
            ),
            Positioned(
                left: 20,
                right: 20,
                child: Container(
                  color: sheetItem.dividerColor,
                  height: 1.0 / MediaQuery.of(context).devicePixelRatio,
                )),
          ],
        ),
        onTap: () {
          Navigator.pop(context);
          if (onTap != null) {
            onTap!(sheetItem);
          }
        },
      );
      sheetViews.add(view);
    }
    return sheetViews;
  }

  double _getTotalHeight() {
    double totalHeight = 0.0;
    for (IBottomSheetItem sheetItem in sheetItems) {
      totalHeight = totalHeight + sheetItem.height;
    }
    return totalHeight;
  }
}
