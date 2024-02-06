import "package:flutter/material.dart";
import 'package:lightweight_app/routes/exercise_progress.dart';
import "package:lightweight_app/db_helper/exercise_db.dart";
import 'package:lightweight_app/assets/icons.dart';
import 'package:lightweight_app/assets/styles.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPage();
}

class _ProgressPage extends State<ProgressPage> with TickerProviderStateMixin {
  late final TabController _tabController;
  late ExerciseDBHelper exercideDb;
  List<Exercise> allExerciseList = [];
    
  void _refreshExercises() async {
    final List<Exercise> data = await exercideDb.getAllExercise();

    setState(() {
      allExerciseList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    exercideDb = ExerciseDBHelper();
    exercideDb.openExercise().whenComplete(() async {
      _refreshExercises();
      setState(() {
        
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: exerciseListView(),
    );
  }

  Widget exerciseListView() {
    if(allExerciseList.isEmpty) {
      return const Center(
        child: Text('No Exercises'),
      );
    }
    else {
      return Padding(
        padding: const EdgeInsets.only(
          top: 10,
        ),
        child: ListView.builder(
          itemCount: allExerciseList.length,
          itemBuilder: (context, index) {
            EdgeInsets p;
            if(index == allExerciseList.length - 1) {
              p = const EdgeInsets.only(
                bottom: 90,
                left: 5,
                right: 5,
              );
            }
            else {
              p = Styles().listViewPadding();
            }

            return  Padding(
              padding: p,
              child: ElevatedButton(
                style: Styles().listViewButtonStyle(),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ExerciseProgress(anExercise: allExerciseList[index]),
                      settings: const RouteSettings(name: '/exercise_progress'),
                    ),
                  );
                },
                child: ListTile( 
                  title: Text(allExerciseList[index].name),
                  trailing: MyIcons().forwardArrowIcon(),
                ),
              ),
            );
          }
        ),
      );
    }
  }
}