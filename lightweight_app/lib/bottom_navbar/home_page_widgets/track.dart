import 'package:flutter/material.dart';
import 'package:lightweight_app/db_helper/exercise_db.dart';
import 'package:lightweight_app/db_helper/workout_db.dart';
import 'package:lightweight_app/icons.dart';
import 'package:lightweight_app/styles.dart';

class Track extends StatefulWidget {
  const Track({
    super.key,
    required this.todaysWorkout,
  });

  final Workout todaysWorkout;

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  late ExerciseDBHelper exerciseDb;
  late List<Map<int, (TextEditingController, TextEditingController)>> _controller;

  @override
  void initState() {
    super.initState();
    exerciseDb = ExerciseDBHelper();
    exerciseDb.openExercise();
    _controller = [];

    for(int i = 0; i < widget.todaysWorkout.exerciseList.length; ++i) {
      int sets = int.parse(widget.todaysWorkout.setsList[i]);
      Map<int, (TextEditingController, TextEditingController)> mapSets = {};

      for(int j = 0; j < sets; ++j) {
        TextEditingController rc = TextEditingController();
        TextEditingController wc = TextEditingController();

        rc.text = '0';
        wc.text = '0';

        // add controller maps
        mapSets.putIfAbsent(j, () => (rc, wc));
      }
      _controller.add(mapSets);
    }
  }

  @override
  void dispose() {
    super.dispose();

    for(int i = 0; i < widget.todaysWorkout.exerciseList.length; ++i) {
      _controller[i].forEach((k, v) {
        v.$1.clear();
        v.$2.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track'),
      ),
      body: checkTodaysWorkout(),
    );
  }

  Widget checkTodaysWorkout() {
    if(widget.todaysWorkout.id == 'RestDay') {
      return const Center(
          child: Text('Rest Day'),
      );
    }
    else {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: widget.todaysWorkout.exerciseList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: Styles().listViewPadding(),
              child: ElevatedButton(
                style: Styles().listViewButtonStyle(), 
                onPressed: () {
                  trackExerciseDialog(index);
                },
                child: ListTile(
                  title: Text(widget.todaysWorkout.exerciseList[index].name),
                  trailing: MyIcons().forwardArrowIcon(),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  void trackExerciseDialog(int i) {
    Exercise anExercise = widget.todaysWorkout.exerciseList[i];
    int numOfSets = int.parse(widget.todaysWorkout.setsList[i]);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SizedBox(
          height: 550,
          child: Column(
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  anExercise.name,
                  style: Styles().largeDialogHeader(), 
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                ),
                child: Divider(
                  thickness: 2,
                ),
              ),
              SizedBox(
                height: 450,
                width: 350,
                child: ListView.builder(
                  itemCount: numOfSets,
                  itemBuilder: (BuildContext context, int index) {
                    int set = index + 1;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Set $set',
                                style: Styles().content(),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 15,
                            right: 15,
                            bottom: 20,
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 100,
                                height: 50,
                                child: TextField(
                                  maxLength: 3,
                                  keyboardType: TextInputType.number,
                                  controller: _controller[i][index]!.$1,
                                  decoration: Styles().inputReps(),
                                  textAlign: TextAlign.center, 
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    int sets = int.parse(_controller[i][index]!.$1.text) + 1; 
                                    _controller[i][index]!.$1.text = sets.toString();  
                                   // widget.workout.setsList[i] = sets.toString();
                                  }); 
                                },
                                child: MyIcons().incrementIcon(),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                      int sets = int.parse(_controller[i][index]!.$1.text) - 1; 
                                      _controller[i][index]!.$1.text = sets.toString();  
                                      //widget.workout.setsList[i] = sets.toString();
                                  }); 
                                },
                                child: MyIcons().decrementIcon(),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 20,
                          ),
                          child: Row(
                            children: <Widget>[
                             SizedBox(
                                width: 100,
                                height: 50,
                                child: TextField(
                                  maxLength: 3,
                                  keyboardType: TextInputType.number,
                                  controller: _controller[i][index]!.$2,
                                  decoration: Styles().inputWeight(),
                                  textAlign: TextAlign.center, 
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    int sets = int.parse(_controller[i][index]!.$2.text) + 1; 

                                    _controller[i][index]!.$2.text = sets.toString();  
                                    //widget.workout.setsList[i] = sets.toString();
                                  }); 
                                },
                                child: MyIcons().incrementIcon(),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    int sets = int.parse(_controller[i][index]!.$2.text) - 1; 

                                    _controller[i][index]!.$2.text = sets.toString();  
                                    //widget.workout.setsList[i] = sets.toString();
                                  }); 
                                },
                                child: MyIcons().decrementIcon(),
                              ),
                            ],
                          ),
                        ),
                        if(set > 0)
                          const Divider(
                            thickness: 2,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
