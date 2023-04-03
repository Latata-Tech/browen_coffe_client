import 'package:flutter/material.dart';

final snackBar = SnackBar(
  content: const Text('Yay! A SnackBar!'),
  action: SnackBarAction(
    label: 'Undo',
    onPressed: () {
      // Some code to undo the change.
    },
  ),
);

SnackBar alert(String content, Color bgColor) {
  return SnackBar(content: Text(content), backgroundColor: bgColor);
}