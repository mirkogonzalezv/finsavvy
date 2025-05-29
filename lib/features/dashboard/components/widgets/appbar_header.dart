// Componente 1: AppBar Personalizado
import 'package:finsavvy/core/consts/theme_consts.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar() {
  return AppBar(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resumen', style: TextStyle(fontSize: 18)),
        Text(
          'Junio 2024',
          style: TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    ),
    actions: [
      IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
    ],
    flexibleSpace: Container(
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
