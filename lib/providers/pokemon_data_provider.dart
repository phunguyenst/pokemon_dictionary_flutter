import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_deck/models/pokemon.dart';
import 'package:pokemon_deck/services/database_service.dart';
import 'package:pokemon_deck/services/http_service.dart';

final pokemonDataProvider =
    FutureProvider.family<Pokemon?, String>((ref, url) async {
  HttpService _httpService = GetIt.instance.get<HttpService>();
  Response? response = await _httpService.get(url);
  if (response != null && response.data != null) {
    return Pokemon.fromJson(response.data);
  }
  return null;
});

final favoritePokemonsProvider =
    StateNotifierProvider<FavoritePokemonProvider, List<String>>((ref) {
  return FavoritePokemonProvider([]);
});

class FavoritePokemonProvider extends StateNotifier<List<String>> {
  final DatabaseService _databaseService =
      GetIt.instance.get<DatabaseService>();
  String FAVORITE_POKEMON_LIST_KEY = "FAVORITE_POKEMON_LIST_KEY";
  FavoritePokemonProvider(
    super._state,
  ) {
    _setup();
  }

  Future<void> _setup() async {
    List<String>? list =
        await _databaseService.getList(FAVORITE_POKEMON_LIST_KEY);
    state = list ?? [];
  }

  void addFavoritePokemon(String url) {
    state = [...state, url];
    _databaseService.saveList(FAVORITE_POKEMON_LIST_KEY, state);
  }

  void removeFavoritePokemon(String url) {
    state = state.where((element) => element != url).toList();
    _databaseService.saveList(FAVORITE_POKEMON_LIST_KEY, state);
  }
}
