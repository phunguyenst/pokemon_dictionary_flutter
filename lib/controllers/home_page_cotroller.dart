import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_deck/models/page_data.dart';
import 'package:pokemon_deck/models/pokemon.dart';
import 'package:pokemon_deck/services/http_service.dart';

class HomePageCotroller extends StateNotifier<HomePageData> {
  final GetIt _getIt = GetIt.instance;
  late HttpService _httpService;

  HomePageCotroller(super._state) {
    _httpService = _getIt.get<HttpService>();
    _setup();
  }

  Future<void> _setup() async {
    loadData();
  }

  Future<void> loadData() async {
    if (state.data == null) {
      Response? response = await _httpService
          .get("https://pokeapi.co/api/v2/pokemon?limit=20&offset=0");
      if (response != null && response.data != null) {
        PokemonListData data = PokemonListData.fromJson(response.data);
        state = state.copyWith(data: data);
        print("Data loaded successfully");
        print(state.data?.results?.length);
      }
    } else {
      if (state.data?.next != null) {
        Response? response = await _httpService.get(state.data!.next!);
        if (response != null && response.data != null) {
          PokemonListData data = PokemonListData.fromJson(response.data);
          state = state.copyWith(
              data: state.data!.copyWith(
            results: [...state.data!.results!, ...data.results!],
            next: data.next,
          ));
          print("Data loaded successfully");
          print(state.data?.results?.length);
        }
      }
    }
  }
}
