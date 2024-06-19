import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_deck/models/pokemon.dart';
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
  FavoritePokemonProvider(
    super._state,
  ) {
    _setup();
  }

  Future<void> _setup() async {}

  void addFavoritePokemon(String url) {
    state = [...state, url];
  }

  void removeFavoritePokemon(String url) {
    state = state.where((element) => element != url).toList();
  }
}
