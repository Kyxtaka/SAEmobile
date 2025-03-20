
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite/sqflite.dart';
import 'UI/home.dart';
import 'UI/login.dart';
import 'UI/signIn.dart';
import 'UI/themes/theme.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(join(await getDatabasesPath(), 'task_database.db'),
      onCreate: (db, version) {
  return db.execute(
  'CREATE TABLE TASK(id INTEGER PRIMARY KEY, title TEXT, tags TEXT, nbhours INTEGER, difficulty INTEGER, description TEXT)',
  );
  },
  version:1,
  );
  await Supabase.initialize(
    url: 'https://qwspzcdwzooofvlczlew.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF3c3B6Y2R3em9vb2Z2bGN6bGV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzczODk1NTYsImV4cCI6MjA1Mjk2NTU1Nn0.gHduSJK1OhDoIcuyMYwBdZoqXb4AELmJBcLV9s5iPhc',
  );
  final db = await database;
  runApp(MyApp());
}
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name:'home',
      path: '/',
      builder: (context, state) => Home(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => Login(),
    ),
    GoRoute(
      path:'/signIn',
      builder: (context, state) => SignIn(),
    ),

  ],
);
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.defaultTheme();
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: "IUTables'O",
      home: Home(),
      theme: theme);
  }
