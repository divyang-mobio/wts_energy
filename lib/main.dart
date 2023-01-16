import 'package:flutter/material.dart';
import 'package:wts_energy/views/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
                elevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.black))),
        home: const MainScreen());
  }
}
