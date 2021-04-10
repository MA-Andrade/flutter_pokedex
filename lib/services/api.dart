import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_pokedex/model/pokemon.dart';
import 'package:http/http.dart' as http;

const baseURl = "pokeapi.co";

class Api {
  static Future<Pokemon> getPokemonDetails(int id) async {
    final response = await http.get(Uri.https(baseURl, "/api/v2/pokemon/$id/"));

    if (response.statusCode == 200) {
      return Pokemon.fromJson(jsonDecode(response.body));
    } else {
      // TODO arrumar broad exception
      throw Exception("Failed to load pokemon.");
    }
  }

  static Future<List<Pokemon>> getPokemonUrlList(int size) async {
    var queryParameters = {
      "limit": "$size",
    };
    final response =
        await http.get(Uri.https(baseURl, "/api/v2/pokemon", queryParameters));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return List.generate(size, (index) {
        Pokemon pokemon =
            Pokemon.getPokemonFromUrlList(jsonResponse["results"][index]);
        pokemon.setId(index + 1);
        return pokemon;
      });
    } else {
      // TODO arrumar broad exception
      throw Exception("Failed to load pokemon list.");
    }
  }

  static Future<Image> getPokemonSprite(int id) async {
    final response = await http.get(Uri.https(baseURl, "/api/v2/pokemon/$id"));
    if (response.statusCode == 200) {
      return Image.network(
          jsonDecode(response.body)['sprites']['front_default']);
    } else {
      // TODO arrumar broad exception
      throw Exception("Failed to load pokemon Image.");
    }
  }
}
