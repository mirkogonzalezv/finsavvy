import 'package:flutter/material.dart';

import '../../../../core/consts/theme_consts.dart';
import '../widgets/menu_app.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido!', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      endDrawer: MenuApp(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ThemeConstsApp.backgroundColor, Colors.deepPurpleAccent],
            stops: [0.18, 0.99],
          ),
        ),
      ),
    );
  }
}
