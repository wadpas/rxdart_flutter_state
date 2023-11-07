import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_flutter_state/bloc/api.dart';
import 'package:rxdart_flutter_state/bloc/search_result.dart';

@immutable
class SearchBloc {
  final Sink<String> search;
  final Stream<SearchResult?> results;

  void dispose() {
    search.close();
  }

  factory SearchBloc({required Api api}) {
    final textChanges = BehaviorSubject<String>();

    final Stream<SearchResult?> results = textChanges
        .distinct()
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap<SearchResult?>((String searchTerm) {
      if (searchTerm.isEmpty) {
        return Stream<SearchResult?>.value(null);
      } else {
        return Rx.fromCallable(() => api.search(searchTerm))
            .delay(const Duration(milliseconds: 500))
            .map((res) => res.isEmpty
                ? const SearchResultNoResult()
                : SearchResultWithResults(res))
            .startWith(const SearchResultLoading())
            .onErrorReturnWith((error, _) => SearchResultHasError(error));
      }
    });
    return SearchBloc._(
      search: textChanges.sink,
      results: results,
    );
  }
  const SearchBloc._({
    required this.search,
    required this.results,
  });
}
