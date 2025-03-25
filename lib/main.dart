
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/UI/forms/editForm.dart';
import 'package:saemobile/api/critiqueapi.dart';
import 'package:saemobile/api/viewsmodel/critiquesviewmodel.dart';
import 'package:saemobile/services/local/sqlfliteDatabase.dart';
import 'package:sqflite/sqflite.dart';
import 'UI/accueil.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'UI/avis.dart';
import 'UI/decouverte.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
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
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfiWeb;
  var database = new SqlfliteDatabase();
  final db = await database.database;
  runApp(MyApp(database: db));
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
    GoRoute(
      path: '/decouverte',
      builder: (context, state) => Decouverte(database: Supabase.instance.client),
    ),
    GoRoute(
      path: '/accueil',
      builder: (context, state) => Accueil(database: Supabase.instance.client),
    ),
    GoRoute(
      path: '/avis',
      builder: (context, state) => Avis(),
       routes: <RouteBase>[
         GoRoute(
           path: '/avis/:id',
           builder: (context,state) => EditForm(avis:state.pathParameters['id']),
         ),
       ]
    )
  ],
);
class MyApp extends StatelessWidget {
  final Database database;
  MyApp({required this.database});

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
              ChangeNotifierProvider(
                create: (context) {
                  final critiquesViewModel = CritiqueViewModel.api(
                    CritiqueAPI(database: Supabase.instance.client),
                  );
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    critiquesViewModel.generateCritiques("mail@mail");
                  });
                  return critiquesViewModel;
                },
              ),
              //ChangeNotifierProvider<AuthService>(create: (_) => AuthService()), // Exemple d'authentification
              //ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()), // Exemple de thème
            ],
            child: Consumer<int>( //int ici car le themeProvider ou le settingViewmodel n'est pas encore fait
              builder: (context, number, child) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  theme: theme,
                  title: 'My App',
                  routerConfig: _router,
                );
              },
            ),
          );
        }
    );
  }
}