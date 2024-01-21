import "package:flutter/material.dart";
import "package:path/path.dart";

class Styles {
  // Textstyle for dialog headers
  TextStyle dialogHeader() {
    return const TextStyle(
      fontSize: 16,
    );
  }

  // Textstyle for dialog headers
  TextStyle largeDialogHeader() {
    return const TextStyle(
      fontSize: 18,
    );
  }
  // TextStyle for subtitles
  TextStyle subtitle() {
    return const TextStyle(
      fontSize: 12,
      color: Colors.grey ,
    );
  }

  // TextStyle for contents
  TextStyle content() {
    return const TextStyle(
      fontSize: 14,
    );
  }

  // TextButton for Save 
  Text saveTextButton() {
    return  const Text(
      'Save',
      style: TextStyle(
        fontSize: 18,
      )
    );
  }

  // InputDecoration for TextField
  InputDecoration inputWorkoutName(String name) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      labelText: name,
    );
  } 
}