import 'package:flutter/material.dart';

class DividerAuth extends StatelessWidget {
  const DividerAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white30)),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
          child: Text('O', style: TextStyle(color: Colors.white70)),
        ),
        Expanded(child: Divider(color: Colors.white30)),
      ],
    );
  }
}
