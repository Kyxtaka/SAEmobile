
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'UI/home.dart';
import 'UI/login.dart';
import 'UI/themes/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://qwspzcdwzooofvlczlew.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF3c3B6Y2R3em9vb2Z2bGN6bGV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzczODk1NTYsImV4cCI6MjA1Mjk2NTU1Nn0.gHduSJK1OhDoIcuyMYwBdZoqXb4AELmJBcLV9s5iPhc',
  );
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
  ],
);
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.defaultTheme();
    return MaterialApp.router(debugShowCheckedModeBanner: false,
      title: "IUTables'O",
      theme: theme,
      routerConfig: _router,);
  }

}