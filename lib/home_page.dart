// home_page.dart
import 'package:flutter/material.dart';
import 'meal_plan_creation_page.dart';
import 'database_helper.dart';
import 'meal_plan_display_page.dart';
import 'models.dart';

class HomePage extends StatelessWidget {
  final DatabaseHelper databaseHelper;

  HomePage({required this.databaseHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await databaseHelper.initDatabase();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MealPlanCreationPage(databaseHelper: databaseHelper)),
                );
              },
              child: Text("Create Meal Plan"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16), // Adjusted padding for button size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Set the border radius to make it square
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await databaseHelper.initDatabase();
                await displayAddFoodDialog(context);
              },
              child: Text("Add Food Item"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16), // Adjusted padding for button size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Set the border radius to make it square
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MealPlanDisplayPage(databaseHelper: databaseHelper),
                  ),
                );
              },
              child: Text("View Meal Plan"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16), // Adjusted padding for button size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Set the border radius to make it square
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> displayAddFoodDialog(BuildContext context) async {
    String foodName = "";
    String calories = "";

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Food Item"),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Food Name"),
                onChanged: (value) {
                  foodName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Calories"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  calories = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                addFoodItem(context, foodName, calories);
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> addFoodItem(BuildContext context, String name, String calories) async {
    try {
      int caloriesValue = int.parse(calories);
      await databaseHelper.initDatabase();

      Food newFood = Food(name: name, calories: caloriesValue);
      await databaseHelper.insertFood(newFood);

      print("Added food to database");
    }
    catch (e) {
      print("Error adding food item: $e");
    }
  }
}