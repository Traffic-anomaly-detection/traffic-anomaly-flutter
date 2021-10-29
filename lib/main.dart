import 'package:flutter/material.dart';
import 'package:traffic_anomaly_app/nav_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: const Color(0xff4056CB),
          appBarTheme: const AppBarTheme(
            color: Color(0xff4056CB),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Color(0xff4056CB),
          )),
      home: const NavScreen(),
    );
  }
}
