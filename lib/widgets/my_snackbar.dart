import 'package:adumas/constant/HColor.dart' as c;
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: c.primary,
      content: Text(text),
    ),
  );
}
