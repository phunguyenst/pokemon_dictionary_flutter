import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_deck/models/pokemon.dart';
import 'package:pokemon_deck/providers/pokemon_data_provider.dart';
import 'package:pokemon_deck/widgets/pokemon_stats_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonURL;
  //biến lắng nghe trạng thái thích hay ko thích
  late FavoritePokemonProvider _favoritePokemonProvider;

  PokemonCard({Key? key, required this.pokemonURL}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //khai báo giá trị thích hay ko thích
    _favoritePokemonProvider = ref.watch(favoritePokemonsProvider.notifier);
    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));
    return pokemon.when(data: (data) {
      return _card(context, false, data);
    }, error: (error, stackTrace) {
      return Text('Error: $error');
    }, loading: () {
      return _card(context, true, null);
    });
  }

  Widget _card(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: true,
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
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).height * 0.01,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).height * 0.01,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(pokemon?.name?.toUpperCase() ?? "pokemon",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text('#${pokemon?.id ?? 0}',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))
                ],
              ),
              Expanded(
                child: CircleAvatar(
                  backgroundImage: pokemon != null
                      ? NetworkImage(pokemon.sprites!.frontDefault!)
                      : null,
                  radius: MediaQuery.sizeOf(context).width * 0.1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${pokemon?.moves?.length} moves",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  GestureDetector(
                      onTap: () {
                        _favoritePokemonProvider
                            .removeFavoritePokemon(pokemonURL);
                      },
                      child: const Icon(Icons.favorite, color: Colors.red))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
