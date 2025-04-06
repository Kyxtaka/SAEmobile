
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../api/viewsmodel/critiquesviewmodel.dart';
import '../../api/viewsmodel/userviewmodel.dart';
import '../../models/critique.dart';
import '../global/footer.dart';

class Avis extends StatefulWidget {
  const Avis({super.key});

  @override
  _AvisState createState() => _AvisState();
}

class _AvisState extends State<Avis> {
  // final header = Header();
  late List<Critique> critliste;
  late String memorizedUsername;

  Future<void> getUser() async {
    memorizedUsername = await UserViewModel.getCurrentUser();
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void _showLoading(BuildContext context) {
    showDialog(
      barrierColor: Colors.black.withValues(alpha: 0.5),
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final critiquesViewModel = context.watch<CritiqueViewModel>();
    final userViewModel = context.watch<UserViewModel>();

    Future<void> refreshWidget() async {
      _showLoading(context);
      await critiquesViewModel.refreshDataNoNotify();

      if (Navigator.of(context, rootNavigator: true).canPop()) {
        debugPrint("Pop du dialog...");
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        debugPrint("Aucun dialog à pop !");
      }
      GoRouter.of(context).refresh();
    }

    Future<void> initOnUserChange() async {
      final String currentUser = await UserViewModel.getCurrentUser();
      if (critiquesViewModel.liste.isNotEmpty) {
        if (currentUser != critiquesViewModel.liste.first.user?.mail) refreshWidget();
      }else if (critiquesViewModel.liste.isEmpty) {
        await critiquesViewModel.refreshDataNoNotify();
        if (critiquesViewModel.liste.isNotEmpty) refreshWidget();
      }
    }
    print("Avis widget reconstruit !");
    if (critiquesViewModel.onLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Mes Avis', style: TextStyle(color: Colors.black))),
        bottomNavigationBar: Footer().create(context),
        body: Center(child: CircularProgressIndicator(),),
      );
    }

    if (critiquesViewModel.liste.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Mes Avis', style: TextStyle(color: Colors.black))),
        bottomNavigationBar: Footer().create(context),
        body: Center(
            child: Column(
              children: [
                Text("Aucun avis trouvé"),
                ElevatedButton(
                    onPressed: () async {
                      await refreshWidget();
                    },
                    child: Text("Un problème ? Réactualiser (Fonctionne pas)")
                ),

                // selector généré par chatGPT pour écouter la variable identifier du userViewModel
                // ne fonctionne pas en dirait
                Selector<UserViewModel, String>(
                  selector: (_, userViewModel) => userViewModel.identifier,
                  builder: (context, currentUser, __)  {
                    initOnUserChange();
                    return SizedBox.shrink(); // Widget invisible qui écoute les changements
                  },
                ),

              ],
            )
        ),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(title: Text('Mes Avis', style: TextStyle(color: Colors.black))),
        bottomNavigationBar: Footer().create(context),
        body: Column(
          children: [
            Expanded(
                child:  ListView.builder(
                  itemCount: critiquesViewModel.liste.length,
                  itemBuilder: (BuildContext context, int index) {
                    var critique = critiquesViewModel.liste[index];
                    return critique.renderCard(context, false);
                  },
                ),
            ),

            ElevatedButton(
                onPressed: () async {
                  await refreshWidget();
                },
                child: Text("Un problème ? Réactualiser")
            ),

            // selector généré par chatGPT pour écouter la variable identifier du userViewModel
            // ne fonctionne pas en dirait
            Selector<UserViewModel, String>(
              selector: (_, userViewModel) => userViewModel.identifier,
              builder: (context, currentUser, __) {
                debugPrint("====================== User identifier changed: cu ${currentUser} =======");
                initOnUserChange(); // Appelle la méthode lorsque l'utilisateur change
                return SizedBox.shrink(); // Widget invisible qui écoute les changements
              },
            ),

          ],
        )
      );
    }
  }
}

