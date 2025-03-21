
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/UI/decouverte.dart';
import 'UI/home.dart';
import 'UI/signIn.dart';
import 'UI/login.dart';
import 'UI/themes/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initSupabase() async{
  try {
    await dotenv.load(fileName: ".env");

    await Supabase.initialize(
        url: dotenv.env['SUPABASE_DB_API_URL']??'',
        anonKey: dotenv.env['SUPABASE_ANON_KEY']??''
    );

  } catch (e) {
    debugPrint("Error lors de l'initialisation de supabase $e");
    return;
  }

}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.defaultTheme();
    return FutureBuilder(
      future: initSupabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
            return MaterialApp(
              home: Scaffold(
                body: Center(child: Text("Erreur de chargement de Supabase")),
            ),
          );
        }

        return MultiProvider(
          providers: [
            Provider<SupabaseClient>(create: (_) => Supabase.instance.client),
            Provider<int>(create: (_) => 42),
            //ChangeNotifierProvider<AuthService>(create: (_) => AuthService()), // Exemple d'authentification
            //ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()), // Exemple de thème
          ],
          child: Consumer<int>( //int ici car le themeProvider ou le settingViewmodel n'est pas encore fait
            builder: (context, number, child) {
              return MaterialApp.router(
                title: 'My App',
                routerConfig: GoRouter(
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
                ),
              );
            },
          ),
        );
      }
    );
  }
}