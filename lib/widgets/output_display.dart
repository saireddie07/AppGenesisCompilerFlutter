import 'package:flutter/material.dart';

class OutputDisplay extends StatelessWidget {
  final String output;

  OutputDisplay({required this.output});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Text(
          output,
          style: TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'Courier',
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}