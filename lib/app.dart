import 'package:flutter/material.dart';
import 'package:flutter_pokedex/services/api.dart';
import 'package:flutter_pokedex/widgets/simplePokemonCardGrid.dart';
import 'package:flutter_pokedex/widgets/utils/errorMessages.dart';

import 'model/pokemon.dart';

class MainApp extends StatelessWidget {
  const MainApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Pokedex App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'FlutterMon',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  //var pokemons = <Pokemon>[];
  late Future<Pokemon> latePokemon;

  late Future<List<Pokemon>> pokemonListFuture;

  @override
  void initState() {
    super.initState();
    //latePokemon = Api.getSinglePokemon();
    pokemonListFuture = Api.getPokemonUrlList(898);
    //_getPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
      ),
      body: FutureBuilder(
        future: pokemonListFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
          List<Widget> children = List<Widget>.empty();
          if (snapshot.hasData) {
            print("${snapshot.data![0].name}");
            var pokemonList = snapshot.data!;
            children = <Widget>[
              SimplePokemonCardGrid(pokemonList: pokemonList),
            ];
          } else if (snapshot.hasError) {
            children = [
              SimpleErrorMessage(
                snapshotError: snapshot.error.toString(),
              ),
            ];
          } else {
            children = <Widget>[CircularProgressIndicator()];
          }
          return Column(
            children: children,
          );
        },
      ),
    );
  }
}
