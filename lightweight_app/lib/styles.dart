import "package:flutter/material.dart";
import "package:lightweight_app/icons.dart";

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
      color: Colors.white,
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

  // Padding for ListView that builds ButtonCards
  EdgeInsets listViewPadding() {
    return const EdgeInsets.only(
      left: 5,
      right: 5,
      bottom: 10,
    );
  }

  // Button style for buttonCards in ListView
  ButtonStyle listViewButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Container deleteButtonCardBackground() {
    return Container(
      color: Colors.red,
      child: Row(
        children: <Widget>[
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: MyIcons().deleteIcon(),
          ),
        ],
      ),
    );
  }
}