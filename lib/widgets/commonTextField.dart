
import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final String hintText;
  CommonTextField({
    required this.hintText
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: hintText,
      ),
    );
  }
}