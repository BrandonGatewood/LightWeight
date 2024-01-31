import "package:flutter/material.dart";
import "package:lightweight_app/db_helper/user_db.dart";
import "package:lightweight_app/icons.dart";
import "package:lightweight_app/styles.dart";
import "package:path/path.dart";

class Summary extends StatelessWidget {
  Summary({
    super.key,
    required this.workoutName,
    required this.aUser,
    required this.userDb,
    required this.callbackBodyWeight,
  });

  final String workoutName;
  final User aUser;
  final UserDBHelper userDb;
  final Function callbackBodyWeight;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return 
       Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: <Widget>[
              // Todays Workout
              Expanded(
                child: todaysWorkoutCard(context, 'Today\'s Workout', workoutName),
              ),
              const Padding(
                padding: EdgeInsets.all(5)
              ),
              // Weight
              Expanded(
                child: bodyWeightButtonCard(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Function to generate a card for the summary section
  Card todaysWorkoutCard(BuildContext context, String title, String content) {
    return Card( 
      elevation: 0,
      color: Theme.of(context).colorScheme.inversePrimary,
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Styles().cardTitle(),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  content,
                  style: Styles().content(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to generate buttonCard
  ElevatedButton bodyWeightButtonCard(BuildContext context) {
    String bodyWeight = aUser.getCurrentBodyWeight();

    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.inversePrimary),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
      onPressed: () {
        selectDialog(context);
      }, 
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Body Weight',
                    style: Styles().content(), 
                  ),
                  const Spacer(),
                  MyIcons().forwardArrowIcon(),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  '$bodyWeight lbs',
                  style: Styles().cardInfo(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectDialog(BuildContext context) {
    //if(aUser.date == 0 || aUser.nextDate == DateTime.now().month) {
    if(aUser.date == 0 || aUser.nextDate == 2) {
      updateBodyWeightDialog(context);
    }
    else {
      bodyWeightDialog(context);
    }
  }

  // When bodyweight doesnt nee to be updated.
  // Dialog with a Column of widgets .
  void bodyWeightDialog(BuildContext context) {
    const Map<int, String> monthMap = {1: "January", 2: "February", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: 'August', 9: 'September', 10: 'October', 11: 'November', 12: 'December'};
    String nextMonth = monthMap[aUser.nextDate].toString();

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SizedBox(
          height: 215.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: MyIcons().backArrowIcon(),
                  ),
                  const Spacer(),
                  const Spacer(),
                  Text(
                    'Body Weight',
                    style: Styles().largeDialogHeader(), 
                  ),
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
              const Spacer(),
              Text('Next weigh in: $nextMonth'),
              const Spacer(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  // When bodyweight needs to be updated.
  // Dialog with a Column of widgets for users to enter their new bodyweight.
  void updateBodyWeightDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SizedBox(
          height: 215.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: MyIcons().backArrowIcon(),
                  ),
                  const Spacer(),
                  const Spacer(),
                  Text(
                    'Body Weight',
                    style: Styles().largeDialogHeader(), 
                  ),
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 10,
                  right: 10,
                  bottom: 5, 
                ),
                child: TextField(
                  maxLength: 3,
                  controller: _controller,
                  onSubmitted: (String value) async {
                    if(_controller.text.isNotEmpty) {
                      onSubmitAdd();
                      callCallback();
                      Navigator.pop(context);
                    }
                  },
                  decoration: Styles().inputWorkoutName('Exercise name'),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ), 
                  child: TextButton(
                    onPressed: () {
                      if(_controller.text.isNotEmpty) {
                        onSubmitAdd();
                        callCallback();
                        Navigator.pop(context);
                      }
                    }, 
                    child: Styles().saveTextButton(),
                  ),
                ),
              ),
            ],              
          ),
        ),
      ),
    );
  }

  void onSubmitAdd() async {

    String bw = aUser.bodyWeightString;
    String newBw = _controller.text;
    bw = '$bw;$newBw';

    int date = DateTime.now().month;

    await userDb.updateBodyWeight(bw);
    await userDb.updateDate(date);
  }

  void callCallback() async {
    User updatedUser = await userDb.getUser();
    callbackBodyWeight(updatedUser);
  }
}