import "package:flutter/material.dart";
import "package:lightweight_app/db_helper/user_db.dart";
import "package:lightweight_app/icons.dart";
import "package:lightweight_app/styles.dart";

class Summary extends StatefulWidget {
  const Summary({
    super.key,
    required this.workoutName,
    required this.aUser,
    required this.userDb,
    required this.callbackUser,
  });

  final String workoutName;
  final User aUser;
  final UserDBHelper userDb;
  final Function callbackUser;

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  late TextEditingController _controller; 

  void _refreshUser() async {
    setState(() {
      widget.callbackUser();
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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
                child: todaysWorkoutCard(context, 'Today\'s Workout', widget.workoutName),
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
    String bodyWeight = widget.aUser.getCurrentBodyWeight();

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
    if(widget.aUser.date == 0 || widget.aUser.nextDate == DateTime.now().month) {
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
    String nextMonth = monthMap[widget.aUser.nextDate].toString();

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SizedBox(
          height: 240.0,
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
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 12
                ),
                child: Divider(
                  thickness: 2,
                ),
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
    String bw = widget.aUser.bodyWeightString;
    String newBw = _controller.text;
    bw = '$bw;$newBw';

    int date = DateTime.now().month;

    await widget.userDb.updateBodyWeight(bw);
    await widget.userDb.updateDate(date);

    _controller.clear();
    _refreshUser();
  }
}