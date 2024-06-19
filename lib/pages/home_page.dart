import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_deck/controllers/home_page_cotroller.dart';
import 'package:pokemon_deck/models/page_data.dart';
import 'package:pokemon_deck/models/pokemon.dart';
import 'package:pokemon_deck/providers/pokemon_data_provider.dart';
import 'package:pokemon_deck/widgets/pokemon_card.dart';
import 'package:pokemon_deck/widgets/pokemon_list_tile.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageCotroller, HomePageData>((ref) {
  return HomePageCotroller(HomePageData.initial());
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late HomePageCotroller _homePageCotroller;
  late HomePageData _homePageData;
  final ScrollController _allPokemonListController = ScrollController();

  late List<String> _favoritePokemons;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _allPokemonListController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _allPokemonListController.removeListener(_scrollListener);
    _allPokemonListController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_allPokemonListController.offset >=
            _allPokemonListController.position.maxScrollExtent &&
        !_allPokemonListController.position.outOfRange) {
      print("reach the bottom");
      _homePageCotroller.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageCotroller = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);
    _favoritePokemons = ref.watch(favoritePokemonsProvider);
    return Scaffold(
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.02),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _favoritePokemonList(context),
              _allPokemonsList(context),
            ]),
      ),
    ));
  }

  Widget _favoritePokemonList(BuildContext context) {
    // return SizedBox(
    //   width: MediaQuery.sizeOf(context).width,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const Text(
    //         "Favorite pokemon",
    //         style: TextStyle(
    //           fontSize: 25,
    //         ),
    //       ),
    //       SizedBox(
    //         height: MediaQuery.sizeOf(context).height * 0.25,
    //         child: ListView.builder(
    //           itemCount: _favoritePokemons.length,
    //           itemBuilder: (context, index) {
    //             return PokemonListTile(pokemonURL: _favoritePokemons[index]);
    //           },
    //         ),
    //       )
    //     ],
    //   ),
    // );
    return SizedBox(
      //lớp bọc ngoài cùng
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Favorite pokemon",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            //lớp bọc 1
            height: MediaQuery.sizeOf(context).height * 0.50,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              children: [
                if (_favoritePokemons.isNotEmpty)
                  SizedBox(
                    //lớp bọc 2 size của card

                    height: MediaQuery.sizeOf(context).height * 0.48,
                    child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: _favoritePokemons.length,
                        itemBuilder: (context, index) {
                          String PokemonURL = _favoritePokemons[index];
                          PokemonListResult();
                          //lớp bọc 3 thành phần mỗi card
                          return PokemonCard(pokemonURL: PokemonURL);
                        }),
                  ),
                if (_favoritePokemons.isEmpty)
                  const Text("No favorite pokemon"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _allPokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "All pokemon",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.65,
            child: ListView.builder(
              controller: _allPokemonListController,
              itemCount: _homePageData.data?.results?.length ?? 0,
              itemBuilder: (context, index) {
                PokemonListResult pokemon =
                    _homePageData.data?.results?[index] ?? PokemonListResult();
                return PokemonListTile(pokemonURL: pokemon.url ?? "");
              },
            ),
          )
        ],
      ),
    );
  }
}
