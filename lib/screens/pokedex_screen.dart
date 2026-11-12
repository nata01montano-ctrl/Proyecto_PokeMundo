
import 'package:flutter/material.dart';

import '../services/pokemon_service.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class PokedexScreen extends StatefulWidget {

  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {

  final PokemonService pokemonService = PokemonService();

  late Future<List<Map<String, dynamic>>> pokemonFuture;

  final Set<int> favorites = {};

  String searchText = '';

  bool showFavorites = false;

  @override
  void initState() {
    super.initState();

    pokemonFuture = pokemonService.getPokemonList();
  }

  // RECARGAR POKÉMON
  void loadPokemon() {

    setState(() {
      pokemonFuture = pokemonService.getPokemonList();
    });
  }

  // AGREGAR O QUITAR FAVORITOS
  void toggleFavorite(int id) {

    setState(() {

      if (favorites.contains(id)) {
        favorites.remove(id);
      } else {
        favorites.add(id);
      }

    });
  }

  // POKÉMON ALEATORIO
  Future<void> randomPokemon() async {

    try {

      final pokemon =
          await pokemonService.getRandomPokemon();

      if (!mounted) return;

      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (context) {
            return PokemonDetailScreen(
              pokemon: pokemon,
            );
          },
        ),
      );

    } catch (error) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo encontrar el Pokémon'),
        ),
      );
    }
  }

  // ABRIR DETALLES
  void openDetails(Map<String, dynamic> pokemon) {

    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) {
          return PokemonDetailScreen(
            pokemon: pokemon,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        children: [

          // BUSCADOR
          TextField(

            decoration: InputDecoration(
              hintText: 'Buscar Pokémon...',
              prefixIcon: const Icon(Icons.search),

              filled: true,
              fillColor: Colors.white,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),

            onChanged: (value) {

              setState(() {
                searchText = value.toLowerCase().trim();
              });

            },
          ),

          const SizedBox(height: 12),

          // BOTÓN ALEATORIO
          SizedBox(
            width: double.infinity,

            child: ElevatedButton.icon(

              onPressed: randomPokemon,

              icon: const Icon(Icons.casino),

              label: const Text(
                '¡Descubrir Pokémon aleatorio!',
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFCB05),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(13),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // FILTROS
          Row(
            children: [

              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      showFavorites = false;
                    });
                  },

                  child: const Text('Todos'),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: OutlinedButton.icon(

                  onPressed: () {
                    setState(() {
                      showFavorites = true;
                    });
                  },

                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 18,
                  ),

                  label: const Text('Favoritos'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // LISTA DE POKÉMON
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(

              future: pokemonFuture,

              builder: (context, snapshot) {

                // CARGANDO
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // ERROR
                if (snapshot.hasError) {

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const Text(
                          'Error al cargar los Pokémon',
                        ),

                        ElevatedButton(
                          onPressed: loadPokemon,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                final pokemonList = snapshot.data ?? [];

                // FILTRAR POKÉMON
                final filteredPokemon = pokemonList.where((pokemon) {

                  final name = pokemon['name']
                      .toString()
                      .toLowerCase();

                  final id = pokemon['id'] as int;

                  final matchesName =
                      name.contains(searchText);

                  final matchesFavorite =
                      !showFavorites || favorites.contains(id);

                  return matchesName && matchesFavorite;

                }).toList();

                if (filteredPokemon.isEmpty) {

                  return Center(
                    child: Text(
                      showFavorites
                          ? 'Todavía no tienes favoritos'
                          : 'No se encontraron Pokémon',
                    ),
                  );
                }

                // MOSTRAR TARJETAS
                return GridView.builder(

                  itemCount: filteredPokemon.length,

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.70,
                  ),

                  itemBuilder: (context, index) {

                    final pokemon = filteredPokemon[index];

                    final id = pokemon['id'] as int;

                    return PokemonCard(

                      pokemon: pokemon,

                      isFavorite: favorites.contains(id),

                      onFavorite: () {
                        toggleFavorite(id);
                      },

                      onTap: () {
                        openDetails(pokemon);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}