
import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonService {
  final String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  // Obtener los primeros 20 Pokémon
  Future<List<Map<String, dynamic>>> getPokemonList() async {
    final response = await http.get(
      Uri.parse('$baseUrl?limit=20&offset=0'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al consultar los Pokémon');
    }

    final data = jsonDecode(response.body);
    final List results = data['results'];

    final pokemonList = await Future.wait(
      results.map((pokemon) async {
        final detailResponse = await http.get(
          Uri.parse(pokemon['url']),
        );

        if (detailResponse.statusCode != 200) {
          throw Exception('Error al cargar un Pokémon');
        }

        return jsonDecode(detailResponse.body)
            as Map<String, dynamic>;
      }),
    );

    return pokemonList;
  }

  // Buscar un Pokémon por su nombre o número
  Future<Map<String, dynamic>> getPokemonByName(String name) async {
    final response = await http.get(
      Uri.parse('$baseUrl/${name.toLowerCase().trim()}'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)
          as Map<String, dynamic>;
    } else {
      throw Exception('Pokémon no encontrado');
    }
  }

  // Obtener un Pokémon aleatorio
  Future<Map<String, dynamic>> getRandomPokemon() async {
    final randomId =
        DateTime.now().microsecondsSinceEpoch % 1025 + 1;

    return await getPokemonByName(randomId.toString());
  }
}
