import 'dart:async';

import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:app_peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey = 'e9b5346384e97565f9276c739c1a6bca';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;

  List<Pelicula> _populares = new List();

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStream() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language,
    });

    return await _procesarRespuesta(url);
    // final resp = await http.get(url);
    // final decodedData = json.decode(resp.body);

    // // print(decodedData['results']);
    // final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    // // print(peliculas.items[1].title);
    // return peliculas.items;
  }

  Future<List<Pelicula>> getPopulares() async {
    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString(),
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    return resp;

    // final resp = await http.get(url);
    // final decodedData = json.decode(resp.body);

    // final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    // return peliculas.items;
  }
}
