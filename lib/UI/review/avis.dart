
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/api/viewsmodel/critiquesviewmodel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';
import '../../models/critique.dart';
import '../global/footer.dart';
import '../global/header.dart';

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

  void showLoading() {
    showDialog(
      barrierColor: Colors.black.withValues(alpha: 0.5),
      context: context,
      builder: (_) =>
          Dialog(
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
    // final userViewModel = context.watch<UserViewModel>();

    Future<void> refreshWidget() async {
      showLoading();
      await critiquesViewModel.refreshDataNoNotify();
      context.pop();
      context.go("/avis");
    }

    Future<void> initOnUserChange() async {
      if (critiquesViewModel.liste.isNotEmpty) {
        // final firstCritique = critiquesViewModel.liste.first;
        final String currentUser = await UserViewModel.getCurrentUser();
        if (memorizedUsername != currentUser) await refreshWidget();
      }
    }

    //selector généré par chatGPT pour écouter la variable identifier du userViewModel
    // ne fonctionne pas en dirait
    Selector<UserViewModel, String>(
      selector: (_, userViewModel) => UserViewModel.identifier,
      builder: (_, currentUser, __) {
        initOnUserChange(); // Appelle la méthode lorsque l'utilisateur change
        return SizedBox.shrink(); // Widget invisible qui écoute les changements
      },
    );


    print("Avis widget reconstruit !");
    print("Avis page liste: ${critiquesViewModel.liste}");

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
                )
              ],
            )
        ),
      );
    }
    else {
      print(" avis page liste ${critiquesViewModel.liste}");
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
            )
          ],
        )
      );
    }
  }


}

