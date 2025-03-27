import 'package:flutter/material.dart';
import 'package:meubar/screens/home_screen.dart';
// ignore: unused_import
import 'package:meubar/screens/map_screen.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Bares',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/',
      routes: {
        '/':
            (context) =>
                HomeScreen(), // Certifique-se de que HomeScreen está definida
        '/map':
            (context) =>
                MapScreen(), // Certifique-se de que MapScreen está definida
      },
    );
  }
}
