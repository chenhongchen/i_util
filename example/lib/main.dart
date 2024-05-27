import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_util/i_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    String longText = '澳洲值得去旅游胜地推荐！' * 1000; // 生成一个非常长的字符串
    longText.toPrint(onlyDebug: false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: const IAppBar(
          hasBackBtn: false,
          backgroundColor: Colors.blue,
          title: Text('Plugin example app'),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: GestureDetector(
              onTap: () {
                showIBottomSheet(
                  context: context,
                  sheetItems: [
                    IBottomSheetItem(text: '是'),
                    IBottomSheetItem(text: '否'),
                    IBottomSheetItem(
                        text: '',
                        height: MediaQuery.of(context).padding.bottom),
                  ],
                );
              },
              child: BorderContainer(
                width: 80,
                height: 80,
                borderRadius: 40,
                borderWidth: 2,
                borderColor: Colors.brown,
                child: FutureBuilder(
                    future: Colors.red.toImage(width: 130, height: 130),
                    builder: (BuildContext context,
                        AsyncSnapshot<Uint8List?> snapshot) {
                      if (snapshot.data == null) {
                        return Container(color: Colors.blue);
                      }
                      return Image.memory(
                        snapshot.data!,
                        width: 100,
                        height: 100,
                        // fit: BoxFit.cover,
                      );
                    }),
              ),
            ),
          );
        }),
      ),
    );
  }
}
