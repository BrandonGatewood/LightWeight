import "package:flutter/material.dart";

class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: <Widget>[
              // Todays Workout
              Expanded(
                child:Card( 
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: const SizedBox(
                    height: 80,
                    child: Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Text('days missed'),
                    ),
                  ),
                ),
              ),
              // Weight
              Expanded(
                child: Card( 
                  elevation: 0,
                  color: Theme.of(context).colorScheme.primary,
                  child: SizedBox(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text('Weight Card',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  
  
}