// meal_plan_display_page.dart
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'meal_plan_creation_page.dart';
import 'models.dart';
import 'package:intl/intl.dart';

class MealPlanDisplayPage extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  MealPlanDisplayPage({required this.databaseHelper});

  @override
  _MealPlanDisplayPageState createState() => _MealPlanDisplayPageState();
}

class _MealPlanDisplayPageState extends State<MealPlanDisplayPage> {
  final TextEditingController dateController = TextEditingController();
  List<MealPlan> mealPlanList = [];

  @override
  void initState() {
    super.initState();
    // _fetchMealPlanList();
  }

  Future<void> getMealPlanList(DateTime date) async {
    List<MealPlan> mealPlans = await widget.databaseHelper.getMealPlans(date);
    setState(() {
      mealPlanList = mealPlans;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal Plan Display Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
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
                  getMealPlanList(pickedDate);
                }
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: mealPlanList.length,
                itemBuilder: (context, index) {
                  return buildMealPlanItem(mealPlanList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMealPlanItem(MealPlan mealPlan) {
    return ListTile(
      title: Text("Name: ${mealPlan.name},\nCalories: ${mealPlan.calories}"),
      subtitle: Text("Date: ${mealPlan.date}"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              editMealPlanItem(mealPlan);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteMealPlanItem(mealPlan);
            },
          ),
        ],
      ),
    );
  }

  Future<void> editMealPlanItem(MealPlan mealPlan) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealPlanCreationPage(
          databaseHelper: widget.databaseHelper,
          preFilledMealPlan: mealPlan,
        ),
      ),
    );
  }

  Future<void> deleteMealPlanItem(MealPlan mealPlan) async {
    if (mealPlan.uid != null) {
      await widget.databaseHelper.deleteMealPlan(mealPlan.uid!);
      getMealPlanList(mealPlan.date); // Update the meal plan list after deletion
    }
  }
}