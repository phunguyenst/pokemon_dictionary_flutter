import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_deck/models/pokemon.dart';
import 'package:pokemon_deck/providers/pokemon_data_provider.dart';
import 'package:pokemon_deck/widgets/pokemon_stats_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonURL;
  late FavoritePokemonProvider _favoritePokemonProvider;
  late List<String> _favoritePokemons;
  PokemonListTile({Key? key, required this.pokemonURL}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));
    _favoritePokemonProvider = ref.watch(favoritePokemonsProvider.notifier);
    _favoritePokemons = ref.watch(favoritePokemonsProvider);
    return pokemon.when(data: (data) {
      return _tile(context, false, data);
    }, error: (error, stackTrace) {
      return Text('Error: $error');
    }, loading: () {
      return _tile(context, true, null);
    });
  }

  Widget _tile(BuildContext context, bool isLoading, Pokemon? pokemon) {
    // bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Skeletonizer(
      enabled: isLoading,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
              context: context,
              builder: (_) {
                return PokemonStatsCard(pokemonURL: pokemonURL);
              },
            );
          }
        },
        child: ListTile(
          // leading: pokemon != null
          //     ? Image.network(
          //         pokemon.sprites!.frontDefault!,
          //         width: 50,
          //         height: 50,
          //       )
          //     : null,
          leading: pokemon != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
                )
              : CircleAvatar(),
          title: Text(pokemon != null ? pokemon.name!.toUpperCase() : ''),
          subtitle: Text("Has ${pokemon?.moves?.length.toString() ?? 0} moves"),
          trailing: IconButton(
            onPressed: () {
              if (_favoritePokemons.contains(pokemonURL)) {
                _favoritePokemonProvider.removeFavoritePokemon(pokemonURL);
              } else {
                _favoritePokemonProvider.addFavoritePokemon(pokemonURL);
              }
            },
            icon: _favoritePokemons.contains(pokemonURL)
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
