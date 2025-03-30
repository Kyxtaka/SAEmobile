import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';

class AddCritiquePage extends StatefulWidget {

  final int restID;

  const AddCritiquePage({super.key, required this.restID});

  @override
  State<AddCritiquePage> createState() => _AddCritiquePageState();
}

class _AddCritiquePageState extends State<AddCritiquePage> {

  late Future<void> _loadDataFuture;
  late String user_identifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    final identifier = await UserViewModel.getCurrentUser();
    user_identifier = identifier;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: Header.create(),
      bottomNavigationBar: Footer().create(context),
      body: FutureBuilder(
          future: _loadDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator(),);
            }

            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            return Center(
              child: Text("data resstID: ${widget.restID} user_identifier: $user_identifier"),
            );

          }
      ),
    );
  }
}