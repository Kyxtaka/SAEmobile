
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:saemobile/UI/decouverte.dart';
import 'UI/home.dart';
import 'UI/signIn.dart';
import 'UI/login.dart';
import 'UI/themes/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    await Supabase.initialize(
        url: dotenv.env['SUPABASE_DB_API_URL']??'',
        anonKey: dotenv.env['SUPABASE_ANON_KEY']??''
    );
  } catch (e) {
    debugPrint("supabase and are already initialized");
  }

  final database = Supabase.instance.client;

  runApp(MyApp(database: database,));
}

class MyApp extends StatelessWidget {
  late final SupabaseClient database;

  MyApp({required this.database});

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
      GoRoute(
        path: '/decouverte',
        builder: (context, state) => Decouverte(database: Supabase.instance.client),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.defaultTheme();
    return MaterialApp.router(debugShowCheckedModeBanner: false,
      title: "IUTables'O",
      theme: theme,
      routerConfig: _router,);
  }
}