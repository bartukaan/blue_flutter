import 'package:flutter/material.dart';

import 'device_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (BuildContext context) => BluetoothDevicesListScreen(),
      },
      initialRoute: "/",
    );
  }
}
