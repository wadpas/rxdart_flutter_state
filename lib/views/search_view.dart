import 'package:flutter/material.dart';
import 'package:rxdart_flutter_state/bloc/search_result.dart';
import 'package:rxdart_flutter_state/models/animal.dart';
import 'package:rxdart_flutter_state/models/person.dart';

class SearchView extends StatelessWidget {
  final Stream<SearchResult?> searchResult;
  const SearchView({
    super.key,
    required this.searchResult,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: searchResult,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data;
          if (result is SearchResultHasError) {
            return const Text('Got error');
          } else if (result is SearchResultLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (result is SearchResultNoResult) {
            return const Text('No results');
          } else if (result is SearchResultWithResults) {
            final results = result.results;
            return Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final item = results[index];
                  final String title;
                  if (item is Animal) {
                    title = 'Animal';
                  } else if (item is Person) {
                    title = "Person";
                  } else {
                    title = "Unknown";
                  }
                  return ListTile(
                    title: Text(title),
                    subtitle: Text(item.toString()),
                  );
                },
              ),
            );
          } else {
            return const Text('Unknown state');
          }
        } else {
          return const Text('Waiting');
        }
      },
    );
  }
}
