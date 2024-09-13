import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/home_page.dart';
import 'package:todo/models/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For persisting theme preference

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>('Todos');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();  // Load the saved theme preference on startup
  }

  // Load the saved theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;  // Default to light mode
    });
  }

  // Save the selected theme mode to SharedPreferences
  Future<void> _saveThemePreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  // Toggle theme and persist preference
  void _toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
    _saveThemePreference(value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo',
      theme: ThemeData(
        colorScheme:  ColorScheme.light(
          primary: Colors.blue,
          onPrimary: Colors.blue.shade50,
          secondary: Colors.red,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.black45,
          onPrimary: Colors.white12,
          secondary: Colors.red,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,  // Toggle between dark and light mode
      home: HomePage(
        title: 'Todo',
        toggleTheme: _toggleTheme,
        isDarkMode: isDarkMode,
      ),
    );
  }
}
