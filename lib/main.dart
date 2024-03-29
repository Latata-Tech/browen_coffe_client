import 'package:browenz_coffee/page/dashboard.dart';
import 'package:browenz_coffee/page/login.dart';
import 'package:browenz_coffee/page/report.dart';
import 'package:browenz_coffee/page/selling.dart';
import 'package:browenz_coffee/service/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/login',
      routes: {
        '/login': (context) => Login(storage: localStorage,),
        '/dashboard': (context) => Dashboard(storage: localStorage,),
        '/selling': (context) => Selling(storage: localStorage,),
        '/report': (context) => Report(storage: localStorage)
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(storage: localStorage,),
    );
  }
}