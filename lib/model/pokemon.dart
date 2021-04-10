class Pokemon {
  int? id;
  String? name;
  String? url;
  String? spriteUrl;
  int? weight;

  Pokemon();

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    Pokemon pokemon = new Pokemon();
    pokemon.name = json['name'] as String;
    pokemon.id = json['id'] as int;
    pokemon.weight = json['weight'] as int;
    pokemon.spriteUrl = json['sprites']['front_default'] as String;

    return pokemon;
  }

  Map toJson() {
    return {'name': name};
  }

  factory Pokemon.getPokemonFromUrlList(Map<String, dynamic> json) {
    Pokemon pokemon = new Pokemon();
    pokemon.name = json['name'] as String;
    pokemon.url = json['url'] as String;

    return pokemon;
  }

  void setId(int id) {
    this.id = id;
  }

  void getPokemonSprite(Map<String, dynamic> json) {
    this.spriteUrl = json['sprites']['front_default'] as String;
  }
}
