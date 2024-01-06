import "package:flutter/material.dart";

class Plan extends StatelessWidget {
  const Plan({super.key});

    @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        planYourWorkoutsWidget(context),
      ],
    ) ;
  }

  Widget planYourWorkoutsWidget(BuildContext context) {
    return Card( 
      elevation: 0,
      color: Theme.of(context).colorScheme.primary,
      child: SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Plan Your Workouts',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ), 
            ),
          ),
        ),
      ),
    );
  }
  
}