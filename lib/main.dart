//import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/services/api.dart';
import 'package:flutter_pokedex/model/pokemon.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
              PokemonCardView(pokemonList: pokemonList),
            ];
          } else if (snapshot.hasError) {
            children = [
              SimpleErrorMessage(
                snapshot: snapshot,
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

class SimpleErrorMessage extends StatelessWidget {
  const SimpleErrorMessage({Key? key, required this.snapshot})
      : super(key: key);
  final AsyncSnapshot<List<Pokemon>> snapshot;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 60,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text('Error: ${snapshot.error}'),
        )
      ],
    );
  }
}

class PokemonCardView extends StatelessWidget {
  const PokemonCardView({
    Key? key,
    required this.pokemonList,
  }) : super(key: key);

  final List<Pokemon> pokemonList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: pokemonList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: PokemonCard(id: index + 1),
            );
          },
        ),
      ),
    );
  }
}

class PokemonCard extends StatefulWidget {
  PokemonCard({Key? key, required this.id}) : super(key: key);

  int id;

  @override
  State<StatefulWidget> createState() => _PokemonCard();
}

class _PokemonCard extends State<PokemonCard> {
  late Future<Pokemon> pokemon;
  late Future<Image> pokemonSprite;

  @override
  void initState() {
    pokemon = Api.getPokemonDetails(widget.id);
    pokemonSprite = Api.getPokemonSprite(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: pokemon,
        builder:
            (BuildContext context, AsyncSnapshot<Pokemon> pokemonSnapshot) {
          if (pokemonSnapshot.hasData) {
            return cardLayout(pokemonSnapshot.data!);
          } else if (pokemonSnapshot.hasError) {
            return errorMessage(pokemonSnapshot.error!.toString());
          }
          return CircularProgressIndicator.adaptive();
        },
      ),
    );
  }

  Widget errorMessage(String messsage) {
    return Column(
      children: <Widget>[
        const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 60,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text('Error: $messsage'),
        )
      ],
    );
  }

  Widget cardLayout(Pokemon pokemon) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Image.network(pokemon.spriteUrl!),
            title: Text(pokemon.name!.toUpperCase()),
            subtitle: Text("Peso: ${pokemon.weight}"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () {},
                child: const Text('Capturar!'),
              ),
              SizedBox(
                width: 8,
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Fugir!'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
