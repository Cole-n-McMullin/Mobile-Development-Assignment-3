// database.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import "models.dart";

class DatabaseHelper {
  Database? _db;

  Future<Database> initDatabase() async {
    try {
      _db ??= await openDatabase(
        join(await getDatabasesPath(), "your_database.db"),
        onCreate: (db, version) async {
          await db.execute("""
            CREATE TABLE food(
              uid INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              calories INTEGER
            )
          """);
          await db.execute("""
            CREATE TABLE meal_plan(
              uid INTEGER PRIMARY KEY AUTOINCREMENT,
              date TEXT,
              name TEXT,
              calories INTEGER
            )
          """);
        },
        version: 1,
      );

      if (_db == null) {
        throw "Database initialization failed.";
      }

      return _db!;
    }
    catch (e) {
      print("Error initializing database: $e");
      rethrow;
    }
  }

  Future<void> insertFood(Food food) async {
    await _db!.insert("food", food.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<List<Food>> getFoods({int? maxCalories}) async {
    final List<Map<String, dynamic>> maps = maxCalories != null
        ? await _db!.query("food", where: "calories <= ?", whereArgs: [maxCalories])
        : await _db!.query("food");

    return List.generate(maps.length, (i) {
      return Food(
        uid: maps[i]["uid"],
        name: maps[i]["name"],
        calories: maps[i]["calories"],
      );
    });
  }

  Future<void> insertMealPlan(MealPlan mealPlan) async {
    await _db!.insert("meal_plan", mealPlan.toMap());
  }

  Future<List<MealPlan>> getMealPlans(DateTime date) async {
    final List<Map<String, dynamic>> maps = await _db!.query("meal_plan", where: "date = ?", whereArgs: [date.toIso8601String()]);
    return List.generate(maps.length, (i) {
      return MealPlan(
        uid: maps[i]["uid"],
        date: DateTime.parse(maps[i]["date"]),
        name: maps[i]["name"],
        calories: maps[i]["calories"],
      );
    });
  }

  Future<void> updateMealPlan(MealPlan mealPlan) async {
    await _db!.update("meal_plan", mealPlan.toMap(), where: "uid = ?", whereArgs: [mealPlan.uid]);
  }

  Future<void> deleteMealPlan(int uid) async {
    await _db!.delete("meal_plan", where: "uid = ?", whereArgs: [uid]);
  }
}