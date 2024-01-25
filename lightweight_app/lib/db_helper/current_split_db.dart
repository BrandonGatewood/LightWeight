import "package:lightweight_app/db_helper/workout_db.dart";

class CurrentSplit {
  final String id; 
  final String workoutsString;
  List<Workout> workoutList = [];

  CurrentSplit({
    required this.id,
    required this.workoutsString,
  });


  CurrentSplit.fromMap(Map<String, dynamic> item):
    id = item['id'],
    workoutsString = item['woroutsString'];


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workoutsString': workoutsString,
    };
  }
}