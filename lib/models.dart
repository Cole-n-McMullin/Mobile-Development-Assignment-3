class Food {
  int? uid;
  String name;
  int calories;

  Food({this.uid, required this.name, required this.calories});

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "calories": calories,
    };
  }

  Food getDefault() {
    uid = -1;
    name = "default";
    calories = 0;
    return this;
  }
}

class MealPlan {
  int? uid;
  DateTime date;
  String name;
  int calories;

  MealPlan({this.uid, required this.date, required this.name, required this.calories});

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "date": date.toIso8601String(),
      "name": name,
      "calories": calories,
    };
  }

  MealPlan getDefault() {
    uid = -1;
    date = DateTime.now();
    name = "default";
    calories = 0;
    return this;
  }
}