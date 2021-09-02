import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchRecipePage extends StatefulWidget {
  SearchRecipePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchRecipePageState();
}

class _SearchRecipePageState extends State<SearchRecipePage> {
  late FloatingSearchBarController controller;
  late String selectedTerm;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: FloatingSearchBar(
      //   controller: controller,
      //   body: FloatingSearchBarScrollNotifier(
      //     child: SearchResultsListView(
      //       searchTerm: selectedTerm,
      //     ),
      //   ),
      //   builder: (BuildContext context, Animation<double> transition) {
      //
      //   },
      // ),
    );
  }
}

class SearchResultsListView extends StatelessWidget {
  final String searchTerm;

  const SearchResultsListView({
    Key? key,
    required this.searchTerm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (searchTerm.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 64,
            ),
            Text(
              'Start searching',
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      );
    }

    final fsb = FloatingSearchBar.of(context);

    return ListView(
      padding: EdgeInsets.only(top: (fsb?.widget.height ?? 0) + (fsb?.widget.margins?.vertical ?? 0)),
      children: List.generate(
        50,
            (index) => ListTile(
          title: Text('$searchTerm search result'),
          subtitle: Text(index.toString()),
        ),
      ),
    );
  }
}
