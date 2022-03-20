import 'package:flutter/material.dart';
import 'package:seunswap/home_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SEUNswap',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
          secondary: Colors.lightBlue[100],
          background: Colors.white,
          brightness: Brightness.light,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
