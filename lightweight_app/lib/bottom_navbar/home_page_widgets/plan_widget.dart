import "package:flutter/material.dart";
import 'package:lightweight_app/styles.dart';
import 'plan_widgets/my_exercises_widget.dart';
import 'plan_widgets/my_workout_widget.dart';
import 'plan_widgets/my_current_split_widget.dart';

class Plan extends StatelessWidget {
  const Plan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        currentSplitButton(context),
        Row(
          children: <Widget>[
            Expanded( 
              child: miniButton(context, 0),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
            ),
            Expanded( 
              child: miniButton(context, 1),
            ),
          ],
        ),
      ],
    );
  }

  Widget currentSplitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: currentSplitButtonStyle(context),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyCurrentSplit()));
        }, 
        child: currentSplitButtonSizedBox(),
      ),
    );
  }

  ButtonStyle currentSplitButtonStyle(BuildContext context) {
      return ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.inversePrimary),
      );
    }

  SizedBox currentSplitButtonSizedBox() {
    return SizedBox(
      height: 80,
      child: Row(
        children: <Widget>[
          Text(
            'My Current Split',
            style: Styles().largeDialogHeader(), 
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_rounded,
            color: Colors.white, 
          ),
        ],
      ),
    );
  }

  Widget miniButton(BuildContext context, int selection) {
    String title = 'My Exercises';

    if(selection == 0) {
      title = 'My Workouts';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: Styles().listViewButtonStyle(),
        onPressed: () {
          if(selection == 0) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Workouts(),
                settings: const RouteSettings(name: '/workouts'),
              ),
            );
          }
          else if(selection == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Exercises(), 
                settings: const RouteSettings(name: '/exercises'),
              ),
            );
          }
        }, 
        child: minibuttonSizedBox(context, title),
      ),
    );
  }

  SizedBox minibuttonSizedBox(BuildContext context, String title) {
    return SizedBox(
      height: 80,
      child: Row(
        children: <Widget>[
          Text(title,
            style: Styles().largeDialogHeader(),
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
