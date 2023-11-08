import 'package:flutter/material.dart';
import 'package:rxdart_flutter_state/bloc/api.dart';
import 'package:rxdart_flutter_state/bloc/search_bloc.dart';
import 'package:rxdart_flutter_state/views/search_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final SearchBloc _bloc;

  @override
  void initState() {
    _bloc = SearchBloc(api: Api());
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Search..'),
              onChanged: _bloc.search.add,
            ),
            const SizedBox(height: 10),
            SearchView(
              searchResult: _bloc.results,
            )
          ],
        ),
      ),
    );
  }
}
