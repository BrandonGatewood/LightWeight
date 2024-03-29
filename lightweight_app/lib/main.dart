import "package:flutter/material.dart";
import 'package:lightweight_app/db_helper/exercise_db.dart';
import 'package:lightweight_app/routes/track.dart';
import 'package:lightweight_app/db_helper/current_split_db.dart';
import 'package:lightweight_app/db_helper/user_db.dart';
import 'package:lightweight_app/assets/icons.dart';
import 'routes/home_page.dart';
import 'routes/progress_page.dart';
import 'routes/settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const Navigation(),
    );
  }
}

/*
  This class is in charge of the main navigations throughout the app (Home, progress, profile)
*/
class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  // Always start off on HomePage
  int _selectedIndex = 0;
  late CurrentSplit myCurrentSplit;
  late CurrentSplitDBHelper currentSplitDb;
  late ExerciseDBHelper exerciseDb;
  late List<Exercise> allExerciseList = [];
  late User aUser;
  late UserDBHelper userDb;
  late List<Widget> _widgetOptions;

  callbackCurrentSplit() async {
    final CurrentSplit currentSplitData = await currentSplitDb.getCurrentSplit();
    final List<Exercise> allExerciseListData = await exerciseDb.getAllExercise(); 

    setState(() {
      myCurrentSplit.setCurrentSplit(currentSplitData);
      allExerciseList = allExerciseListData;

      _widgetOptions = <Widget>[
        HomePage(myCurrentSplit: myCurrentSplit, currentSplitDb: currentSplitDb, callbackCurrentSplit: callbackCurrentSplit, aUser: aUser, userDb: userDb, callbackUser: callbackUser),
        ProgressPage(allExerciseList: allExerciseList), 
      ]; 
    });
  }

  callbackUser() async {
    final User userData = await userDb.getUser();
    
    setState(() {
      aUser.setUser(userData);

      _widgetOptions = <Widget>[
        HomePage(myCurrentSplit: myCurrentSplit, currentSplitDb: currentSplitDb, callbackCurrentSplit: callbackCurrentSplit, aUser: aUser, userDb: userDb, callbackUser: callbackUser),
        ProgressPage(allExerciseList: allExerciseList), 
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    aUser = User();
    myCurrentSplit = CurrentSplit();
    currentSplitDb = CurrentSplitDBHelper();
    userDb = UserDBHelper();
    exerciseDb = ExerciseDBHelper();
    exerciseDb.openExercise().whenComplete(() async {
      final List<Exercise> data = await exerciseDb.getAllExercise();

      for(int i = 0; i < data.length; ++i) {
        allExerciseList.add(data[i]);
      }

      setState(() {
        allExerciseList;
      });
    });

    _widgetOptions = <Widget>[
      HomePage(myCurrentSplit: myCurrentSplit, currentSplitDb: currentSplitDb, callbackCurrentSplit: callbackCurrentSplit, aUser: aUser, userDb: userDb, callbackUser: callbackUser),
      ProgressPage(allExerciseList: allExerciseList), 
    ]; 
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LightWeight'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                      settings: const RouteSettings(name: '/settings'),
                    ),
                  );
                },
                icon: MyIcons().settingsIcon(), 
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Progress',
          ),
        ],
        currentIndex: _selectedIndex,
        showUnselectedLabels: false,
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        unselectedItemColor: Colors.white, 
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Track(todaysWorkout: myCurrentSplit.getTodaysWorkout(), callbackCurrentSplit: callbackCurrentSplit),
          ));
        },
        label: const Text('Track',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white, 
          ) 
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

