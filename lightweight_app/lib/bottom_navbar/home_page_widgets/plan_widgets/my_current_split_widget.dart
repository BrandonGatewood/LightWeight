import "package:flutter/material.dart";
import 'package:lightweight_app/db_helper/workout_db.dart';
import 'package:lightweight_app/styles.dart';

class MyCurrentSplit extends StatefulWidget {
  const MyCurrentSplit({super.key});

  @override
  State<MyCurrentSplit> createState() => _MyCurrentSplitState();
}

class _MyCurrentSplitState extends State<MyCurrentSplit> with TickerProviderStateMixin{
  late final TabController _tabController;
  List<Workout> myCurrentSplit = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //return planYourWorkoutsWidget(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Current Split'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.blue,
          tabs: const <Widget>[
            Tab(
              text: 'M',
            ),
            Tab(
              text: 'T',
            ),
            Tab(
              text: 'W',
            ),
            Tab(
              text: 'T',
            ),
            Tab(
              text: 'F',
            ),
            Tab(
              text: 'S',
            ),
            Tab(
              text: 'S',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
        tabViewBody(),
        Text('hi'),
        Text('hi'),
        Text('hi'),
        Text('hi'),
        Text('hi'),
        Text('hi'),
        ],
      )
    );
  }

  Column tabViewBody() {
    return const Column(
      children: <Widget> [
        Text('workoutname'),
         Divider(
          thickness: 2,
        ),
      ]
    );
  } 
}