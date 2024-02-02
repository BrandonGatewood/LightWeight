import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:lightweight_app/db_helper/db.dart';

class Exercise {
  final String id;
  final String name;
  final String repsString;
  final String weightString;
  final int maxWeight;

  const Exercise({
    required this.id,
    required this.name,
    required this.repsString,
    required this.weightString,
    required this.maxWeight,
  });

  Exercise.fromMap(Map<String, dynamic> item):
    id = item['id'], name = item['name'], repsString = item['repsString'], weightString = item['weightString'], maxWeight = item['maxWeight'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'repsString': repsString,
      'weightString': weightString,
      'maxWeight': maxWeight,
    };
  }

  List<int> getFirstSetWeightList() {
    if(weightString.isEmpty) {
      return [];
    }
    else {
      List<int> firstSetWeightList = [];
      List<String> allWeightsList = weightString.split(';');
      for(int i = 0; i < allWeightsList.length; ++i) {
        List<String> aWeightsList = allWeightsList[i].split(',');
        int firstWeight = int.parse(aWeightsList[0]); 
        firstSetWeightList.add(firstWeight);
      }
      return firstSetWeightList;
    }
  }

  List<List<int>> getAllWeightsMatrix() {
    List<List<int>> allWeightsMatrix = [];

    List<String> allWeightsList = weightString.split(';');

    for(int i = 0; i < allWeightsList.length; ++i) {

    }
    return allWeightsMatrix;
  }
}

class ExerciseDBHelper {
  Future<Database> openExercise() async {
    return DB().openDB();
  }

  Future<void> insertExercise(String name) async {
    final Database db = await ExerciseDBHelper().openExercise();

    String id = DB().idGenerator(); 

    Exercise newExercise = Exercise(id: id, name: name, repsString: '', weightString: '', maxWeight: 0);

    await db.insert(
      'exercises', 
      newExercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }
  
  Future<dynamic> insertExerciseInSelectExercise(String name) async {
    final Database db = await ExerciseDBHelper().openExercise();

    String id = DB().idGenerator(); 

    Exercise newExercise = Exercise(id: id, name: name, repsString: '', weightString: '', maxWeight: 0);

    await db.insert(
      'exercises', 
      newExercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    return newExercise;
  }



  Future<List<Exercise>> getAllExercise() async {
    final Database db = await ExerciseDBHelper().openExercise();

    final List<Map<String, Object?>> maps = await db.query('exercises');

    return maps.map((e) => Exercise.fromMap(e)).toList()..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),);
  }

  Future<List<Exercise>> getExerciseList(List<String> exerciseIdList) async {
    final Database db = await ExerciseDBHelper().openExercise();
    final List<Map<String, Object?>> maps = await db.query('exercises');

    List<Exercise> exerciseList = [];
    List<Exercise> allExerciseList = maps.map((e) => Exercise.fromMap(e)).toList();

    for(int i = 0; i < exerciseIdList.length; ++i) {
      for(int j = 0; j < allExerciseList.length; ++j) {
        if(exerciseIdList[i] == allExerciseList[j].id) {
          exerciseList.add(allExerciseList[j]);
        }
      }
    }

    return exerciseList;
  }

  Future<void> deleteExercise(String id) async {
    final Database db = await ExerciseDBHelper().openExercise();

      await db.delete(
        'exercises',
        where: "id = ?",
        whereArgs: [id]
      );
  }

  Future<void> updateExercise(String id, String newName) async {
    final Database db = await ExerciseDBHelper().openExercise();

    await db.rawUpdate('UPDATE exercises SET name = ? WHERE id = ?', [newName, id]);
  }

  Future<dynamic> getExercise(String id) async {
    List<Exercise> exerciseList = [];

    final Database db = await ExerciseDBHelper().openExercise();
    List<Map<String, Object?>> e = await db.rawQuery('SELECT * FROM exercises WHERE id = ?', [id]);
    exerciseList = e.map((e) => Exercise.fromMap(e)).toList();

    return exerciseList;
  }

  Future<void> updateExerciseReps(String id, String repsString) async {
    final Database db = await ExerciseDBHelper().openExercise();
    
    await db.rawUpdate('UPDATE exercises SET repsString = ? WHERE id = ?', [repsString, id]);
  }

  Future<void> updateExerciseWeight(String id, String weightString) async {
    final Database db = await ExerciseDBHelper().openExercise();
    
    await db.rawUpdate('UPDATE exercises SET weightString = ? WHERE id = ?', [weightString, id]);
  }

  Future<void> updateExerciseMaxWeight(String id, int maxWeight) async {
    final Database db = await ExerciseDBHelper().openExercise();
    
    await db.rawUpdate('UPDATE exercises SET maxWeight = ? WHERE id = ?', [maxWeight, id]);
  }

}