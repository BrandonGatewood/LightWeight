import "package:flutter/material.dart";
import "package:path/path.dart";

class Styles {
  // Textstyle for dialog headers
  TextStyle dialogHeader() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }

  // TextStyle for card titles
  TextStyle cardTitle() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }

  // TextStyle for subtitles
  TextStyle subtitle() {
    return const TextStyle(
      fontSize: 12,
      color: Colors.grey ,
    );
  }

  // InputDecoration for TextField
  InputDecoration inputWorkoutName(String name) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      labelText: name
    );
  } 
}