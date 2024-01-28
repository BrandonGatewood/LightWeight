import "package:flutter/material.dart";
import 'package:lightweight_app/db_helper/current_split_db.dart';
import 'package:lightweight_app/icons.dart';
import 'bottom_navbar/home_page.dart';
import './bottom_navbar/progress_page.dart';
import './bottom_navbar/settings_page.dart';

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

  callback(CurrentSplit currentSplit) {
    setState(() {
      myCurrentSplit = currentSplit;
      HomePage(myCurrentSplit: myCurrentSplit, currentSplitDb: currentSplitDb, callback: callback);
    });
  }

  @override
  void initState() {
    super.initState();
    myCurrentSplit = CurrentSplit();
    currentSplitDb = CurrentSplitDBHelper();
    currentSplitDb.openCurrentSplit().whenComplete(() async {
      final CurrentSplit data = await currentSplitDb.getCurrentSplit();

      setState(() {
        myCurrentSplit = data;
      });
    });
  }

  Widget selectedNavbar() {
    if(_selectedIndex == 0) {
      return HomePage(myCurrentSplit: myCurrentSplit, currentSplitDb: currentSplitDb, callback: callback,);
    }
    else {
      return const ProgressPage();
    }
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
                  const SettingsPage();
                },
                icon: MyIcons().settingsIcon(), 
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: selectedNavbar(),
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
    );
  }
}

