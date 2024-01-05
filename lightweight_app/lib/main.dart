import "package:flutter/material.dart";
import './bottom_navbar/home_page.dart';
import './bottom_navbar/profile_page.dart';
import './bottom_navbar/progress_page.dart';
import './app_bar/track_workout_page.dart';
import './app_bar/settings_page.dart';

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

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ProgressPage(),
    // MyWorkoutsPage(),
    SettingsPage(),
    SettingsPage(), 
  ];

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
          // Navigate to TrackWorkoutPage
          IconButton(
            icon: const Icon(Icons.track_changes_rounded),
            tooltip: 'Track Workout',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TrackWorkoutPage()));
            },
          ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_rounded),
            label: 'My Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
          
        ],
        currentIndex: _selectedIndex,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white, 
        onTap: _onItemTapped,
      ),
    );
  }
}

