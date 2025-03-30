import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/UI/global/header.dart';

class SearchResult extends StatefulWidget {
  final int cuisine;
  final int carac;

  const SearchResult({required this.cuisine, required this.carac});

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: Header.create(),
      bottomNavigationBar: Footer().create(context),
      body: Center(
        child: Text("Loded with cuisine: ${widget.cuisine} and carac: ${widget.carac}"),
      ),
    );
  }

}