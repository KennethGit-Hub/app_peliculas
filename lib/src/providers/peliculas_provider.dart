import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:app_peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey = 'e9b5346384e97565f9276c739c1a6bca';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language,
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    // print(decodedData['results']);
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    // print(peliculas.items[1].title);
    return peliculas.items;
  }
}
