import 'package:flutter/material.dart';
import 'package:flutter_pokedex/model/pokemon.dart';
import 'package:flutter_pokedex/services/api.dart';
import 'package:flutter_pokedex/widgets/utils/errorMessages.dart';

class SimplePokemonCardGrid extends StatelessWidget {
  const SimplePokemonCardGrid({
    Key? key,
    required this.pokemonList,
  }) : super(key: key);

  final List<Pokemon> pokemonList;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Expanded(
      child: Scrollbar(
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          itemCount: pokemonList.length,
          itemBuilder: (context, index) {
            return GridTile(
              child: PokemonCard(id: index + 1),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
        ),
      ),
    );
  }
}

/*
ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: pokemonList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: PokemonCard(id: index + 1),
            );
          },
        ),
*/

class PokemonCard extends StatefulWidget {
  PokemonCard({Key? key, required this.id}) : super(key: key);

  final int id;
  bool? detailed;

  @override
  State<StatefulWidget> createState() => _PokemonCard();
}

class _PokemonCard extends State<PokemonCard> {
  late Future<Pokemon> pokemon;
  late Future<Image> pokemonSprite;

  @override
  // ignore: must_call_super
  void initState() {
    pokemon = Api.getPokemonDetails(widget.id);
    pokemonSprite = Api.getPokemonSprite(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pokemon,
      builder: (BuildContext context, AsyncSnapshot<Pokemon> pokemonSnapshot) {
        if (pokemonSnapshot.hasData) {
          return cardLayout(pokemonSnapshot.data!);
        } else if (pokemonSnapshot.hasError) {
          return SimpleErrorMessage(
              snapshotError: pokemonSnapshot.error.toString());
        }
        return CircularProgressIndicator.adaptive();
      },
    );
  }

  Widget cardLayout(Pokemon pokemon) {
    return Card(
      color: Colors.amberAccent,
      child: ListTile(
        dense: true,
        leading: Image.network(pokemon.spriteUrl!),
        title: Text(pokemon.name!.toUpperCase()),
        subtitle: Text("Peso: ${pokemon.weight}"),
      ),
    );
  }
}
