import "package:flutter/material.dart";

class Highlight extends StatelessWidget {
  const Highlight({super.key});

  @override
  Widget build(BuildContext context) {
   return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            // Todays Workout
            Expanded(
              child:Card( 
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: const SizedBox(
                  height: 100,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Text('Weight'),
                  ),
                ),
              ),
            ),
            // Weight
            Expanded(
              child: Card( 
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: const SizedBox(
                  height: 100,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Text('card for favorite exercise 2'),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            // Todays Workout
            Expanded(
              child:Card( 
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: const SizedBox(
                  height: 100,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Text('favaorite exercise 3'),
                  ),
                ),
              ),
            ),
            // Weight
            Expanded(
              child: Card( 
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: const SizedBox(
                  height: 100,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Text('card for favorite exercise 4'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}