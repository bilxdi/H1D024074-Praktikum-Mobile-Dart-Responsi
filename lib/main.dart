import 'package:flutter/material.dart';
import 'package:belajarflutter/ui/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Cuaca',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 64.0, fontWeight: FontWeight.w300),
          headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontSize: 14.0),
          bodySmall: TextStyle(fontSize: 12.0),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          surfaceTintColor: Colors.white,
        ),
      ),
      home: const MainPage(),
    );
  }
}