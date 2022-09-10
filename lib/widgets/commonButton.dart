
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const CommonButton({
    required this.title,
    required this.onTap
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height*0.07,
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4)
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(fontSize: 20,color: Colors.white),),
      ),
    );
  }
}