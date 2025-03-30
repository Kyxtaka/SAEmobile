import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';

class AddCritiquePage extends StatefulWidget {

  final int restID;
  final String user_identifier;

  const AddCritiquePage({super.key, required this.restID, required this.user_identifier, required Future<String> user_identifer});

  @override
  State<AddCritiquePage> createState() => _AddCritiquePageState();
}

class _AddCritiquePageState extends State<AddCritiquePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: Header.create(),
      bottomNavigationBar: Footer().create(context),
      body: Center(
        child: Text("data resstID: ${widget.restID} user_identifier: ${widget.user_identifier}"),
      ),
    );
  }
}