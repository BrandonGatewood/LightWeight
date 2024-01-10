import "package:flutter/material.dart";
import './plan/excercise_widget.dart';
import './plan/workout_widget.dart';
import './plan/current_splits_widget.dart';

class Plan extends StatelessWidget {
  const Plan({super.key});

    @override
  Widget build(BuildContext context) {
    //return planYourWorkoutsWidget(context);
    return planButton(context);
  }

  /*
    planButton is the main button for the planning_widget. Its child is a generic SizedBox
    to generate the appropriate button.

    When pressed, this function will call displayOptions function to display.
  */ 
  Widget planButton(BuildContext context) {
    return ElevatedButton(
      style: planButtonStyle(context, true), 
      onPressed: () {
        displayOptions(context);
      }, 
      child: buttonSizedBox('Plan Your Workouts'),
    );
  }

  /* 
    optionsButton is a generic button used for displaying the exercise, workouts, and
    current split buttons. 
    
    Using the passed in integer, it will determine the correct title for the button and 
    correct function to call when pressed.
  */
  Widget optionButton(BuildContext context, int selection) {
    String title = 'Exercise';
    if(selection == 1) {
      title = 'Workouts';
    }
    else if(selection == 2) {
      title = 'Current Split';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: planButtonStyle(context, false),
        onPressed: () {
          if(selection == 0) {
            // Open new page to exercise
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Exercises()));
          }
          else if(selection == 1) {
            // Open new page to workouts
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Workouts()));
          }
          else {
            // Open new page to current workouts
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CurrentSplit()));
          }
        }, 
        child: buttonSizedBox(title)
      ),
    );
  }

  /*
    displayOptions will display the three options the user can make.

    passing in an integer to determine the users selection.
  */
  void displayOptions(BuildContext context) {
    showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Plan your exercises, workouts, and current workout split'),
        actions: <Widget>[
          optionButton(context, 0),
          optionButton(context, 1),
          optionButton(context, 2),
        ],
      )
    );
  }

  /*
    planButtonStyle is a generic ButtonStyle, the passed in boolean will determine
    if the button should be primary color or not.
  */
  ButtonStyle planButtonStyle(BuildContext context, bool mainButton) {
    if(mainButton) {
      return ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.inversePrimary),
      );
    }
    else {
      return ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

/*
  buttonSizedBox is a generic sizedBox use to generate the size of every
  button.
*/
  SizedBox buttonSizedBox(String title) {
    return SizedBox(
      height: 50,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text(title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ), 
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_rounded,
            color: Colors.white, 
          ),
        ],
      ),
    );
  }
}