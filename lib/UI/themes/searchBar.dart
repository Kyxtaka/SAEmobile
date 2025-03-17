import 'package:flutter/material.dart';

class searchBar extends StatefulWidget {
  const searchBar({super.key});
  @override
  State<SearchBar> createState() => _SearchBarState();
}
class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          appBar: AppBar(title: const Text('Search Bar Sample')),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (_) {
                    controller.openView();
                  },
                  leading: const Icon(Icons.search),
                );
              },
              suggestionsBuilder: (BuildContext context,
                  SearchController controller) {
                return List<ListTile>.generate(5, (int index) {
                  final String item = 'item $index';
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      setState(() {
                        controller.closeView(item);
                      });
                    },
                  );
                });
              },
            ),
          ),
        )
    );
  }
}
