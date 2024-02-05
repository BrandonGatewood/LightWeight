import "package:flutter/material.dart";
import 'package:lightweight_app/assets/icons.dart';

class Styles {
  // TextStyle for titles in homepage
  TextStyle cardTitle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  // TextStyle for info in homepage
  TextStyle cardInfo() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    );
  }

  // Textstyle for dialog headers
  TextStyle dialogHeader() {
    return const TextStyle(
      fontSize: 16,
      color: Colors.white,
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
      color: Colors.white,
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
  
  // TextButton for add new exercise in select_exercises 
  Text addTextButton() {
    return  const Text(
      'Add',
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

  // InputDecoration for TextField sets
  InputDecoration inputSets() {
    return const InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'sets',
      counterText: '',
    );
  } 

  // InputDecoration for TextField reps
  InputDecoration inputReps() {
    return const InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'reps',
      counterText: '',
    );
  } 
  InputDecoration inputWeight() {
    return const InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Weight',
      counterText: '',
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