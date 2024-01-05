import "package:flutter/material.dart";

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPage();
}

class _ProgressPage extends State<ProgressPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.blue,
            tabs: const <Widget>[
              Tab(
                text: 'Weight',
                
              ),
              Tab(
                text: 'Reps',
              ),
            ],
          ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Center(
            child: Text('I am Weight',
            style: TextStyle(color: Colors.white),
            ),
          ),
          Center(
            child: Text('I am Reps'),
          ),
        ],
      ),
    );
  }
}