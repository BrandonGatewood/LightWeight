import "package:flutter/material.dart";

class Plan extends StatelessWidget {
  const Plan({super.key});

    @override
  Widget build(BuildContext context) {
    return planYourWorkoutsWidget(context);
  }

  Widget planYourWorkoutsWidget(BuildContext context) {
    return Card( 
      elevation: 0,
      color: Theme.of(context).colorScheme.inversePrimary,
      child: SizedBox(
        height: 50,
        child: Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Plan Your Workouts',
                  style: TextStyle(
                    fontSize: 14,
                  ), 
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {

              }, 
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}