// main.dart
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Create and initialize DatabaseHelper
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.initDatabase();

    runApp(MyApp(databaseHelper: databaseHelper));
  } catch (e) {
    print('Failed to initialize database: $e');
  }
}

class MyApp extends StatelessWidget {
  final DatabaseHelper databaseHelper;

  MyApp({required this.databaseHelper});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark().copyWith(
          primary: Colors.white, // Set the primary color to black
          secondary: Colors.deepPurple, // Set the secondary color to purple
        ),
        scaffoldBackgroundColor: Colors.grey[900], // Set the background color for the scaffold
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.deepPurple,
            onPrimary: Colors.white,
            textStyle: TextStyle(
              fontSize: 20, // Set the text size to 20px
              fontWeight: FontWeight.bold, // Make the text bold
            ),
          )
        ),
      ),
      home: HomePage(databaseHelper: databaseHelper),
    );
  }
}