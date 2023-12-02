// meal_plan_creation_page.dart
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'models.dart';
import 'meal_plan_display_page.dart';

class MealPlanCreationPage extends StatefulWidget {
  final DatabaseHelper databaseHelper;
  final MealPlan? preFilledMealPlan; // Add this line

  MealPlanCreationPage({
    required this.databaseHelper,
    this.preFilledMealPlan, // Add this line
  });

  @override
  _MealPlanCreationPageState createState() => _MealPlanCreationPageState();
}

class _MealPlanCreationPageState extends State<MealPlanCreationPage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController targetCaloriesController = TextEditingController();
  List<Food> foodList = [];
  Food? selectedFood;

  @override
  void initState() {
    super.initState();
    getFoodList(null);

    // Check if preFilledMealPlan is provided and set initial values
    if (widget.preFilledMealPlan != null) {

      MealPlan preFilledPlan = widget.preFilledMealPlan!;

      dateController.text = DateFormat("yyyy-MM-dd").format(preFilledPlan.date);
      targetCaloriesController.text = preFilledPlan.calories.toString();

      getFoodList(preFilledPlan.calories);

      // Set selectedFood based on preFilledPlan.name
      selectedFood = foodList.firstWhereOrNull(
            (food) => food.name == preFilledPlan.name,
      );
    }
  }

  Future<void> getFoodList(int? maxCalories) async {
    List<Food> foods = await widget.databaseHelper.getFoods(maxCalories: maxCalories);
    setState(() {
      foodList = foods;
      selectedFood = foodList.isNotEmpty ? foodList.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal Plan Creation Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 15.0),
              child: TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: "Date"),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );
                  if (pickedDate != null) {
                    dateController.text = DateFormat("yyyy-MM-dd").format(pickedDate);
                  }
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15.0),
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Food>(
                  value: selectedFood,
                  items: foodList.map((Food food) {
                    return DropdownMenuItem<Food>(
                      value: food,
                      child: Text(food.name),
                    );
                  }).toList(),
                  onChanged: (Food? value) {
                    setState(() {
                      selectedFood = value;
                    });
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15.0),
              child: TextField(
                controller: targetCaloriesController,
                decoration: InputDecoration(labelText: "Target Calories per Day"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  getFoodList(int.parse(value));
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15.0),
              child: ElevatedButton(
                onPressed: () {
                  addToMealPlan();
                },
                child: Text("Add to Meal Plan"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MealPlanDisplayPage(databaseHelper: widget.databaseHelper)),
                );
              },
              child: Text("Display Meal Plan"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addToMealPlan() async {
    try {
      await widget.databaseHelper.initDatabase();

      // Ensure selectedFood is not null
      if (selectedFood != null) {

        MealPlan mealPlan = MealPlan(
          date: DateTime.parse(dateController.text),
          name: selectedFood!.name,
          calories: selectedFood!.calories,
        );

        await widget.databaseHelper.insertMealPlan(mealPlan);

        print("Added Meal to Meal Plan");
      }
      else {
        // Handle the case when selectedFood is null
        print("Error: No food selected");
      }
    }
    catch (e) {
      print("Error adding meal plan: $e");
    }
  }
}