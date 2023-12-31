import 'dart:convert';
import 'dart:io';

import 'package:rxdart_flutter_state/models/animal.dart';
import 'package:rxdart_flutter_state/models/person.dart';
import 'package:rxdart_flutter_state/models/thing.dart';

class Api {
  List<Animal>? _animals;
  List<Person>? _persons;
  Api();

  Future<List<Thing>> search(String searchTerm) async {
    final term = searchTerm.trim().toLowerCase();
    final cachedResults = _extract(term);

    if (cachedResults != null) {
      return cachedResults;
    }

    final persons = await _getJson('http://10.0.2.2:5500/apis/persons.json')
        .then((json) => json.map((e) => Person.fromJson(e)));
    _persons = persons.toList();

    final animals = await _getJson('http://10.0.2.2:5500/apis/animals.json')
        .then((json) => json.map((e) => Animal.fromJson(e)));
    _animals = animals.toList();

    return _extract(term) ?? [];
  }

  List<Thing>? _extract(String term) {
    final cachedAnimals = _animals;
    final cachedPersons = _persons;

    if (cachedAnimals != null && cachedPersons != null) {
      List<Thing> result = [];
      for (final animal in cachedAnimals) {
        if (animal.name.trimmedContains(term) ||
            animal.type.name.trimmedContains(term)) {
          result.add(animal);
        }
      }
      for (final person in cachedPersons) {
        if (person.name.trimmedContains(term) ||
            person.age.toString().trimmedContains(term)) {
          result.add(person);
        }
      }
      return result;
    } else {
      return null;
    }
  }

  Future<List<dynamic>> _getJson(String url) => HttpClient()
      .getUrl(Uri.parse(url))
      .then((req) => req.close())
      .then((res) => res.transform(utf8.decoder).join())
      .then((jsonString) => json.decode(jsonString) as List<dynamic>);
}

extension Contain on String {
  bool trimmedContains(String other) => trim().toLowerCase().contains(
        other.trim().toLowerCase(),
      );
}
