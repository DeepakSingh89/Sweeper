
import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String title;
  final Color color;
  final double fontSize;
  const CommonText({
    required this.title,
    required this.color,
    required this.fontSize,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height*0.07,
        child: Text(
          title,
          style: TextStyle(fontSize: fontSize,color: color),),
      ),
    );
  }
}