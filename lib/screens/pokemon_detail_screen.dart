
import 'package:flutter/material.dart';

class PokemonDetailScreen extends StatelessWidget {

  final Map<String, dynamic> pokemon;

  const PokemonDetailScreen({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {

    final name = pokemon['name'].toString();

    final id = pokemon['id'];

    final image = pokemon['sprites']['other']
            ?['official-artwork']
            ?['front_default']
        ?? pokemon['sprites']['front_default'];

    final types = pokemon['types'] as List;

    final abilities = pokemon['abilities'] as List;

    final stats = pokemon['stats'] as List;

    return Scaffold(

      appBar: AppBar(
        title: const Text('Detalles Pokémon'),
        backgroundColor: const Color(0xFFFFCB05),
      ),

      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              // IMAGEN
              Image.network(
                image ?? '',
                height: 220,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 10),

              // NOMBRE
              Text(
                name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                '#${id.toString().padLeft(3, '0')}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                ),
              ),

              const SizedBox(height: 20),

              // TIPOS
              const Text(
                'Tipos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Wrap(
                spacing: 8,

                children: types.map((type) {

                  return Chip(
                    label: Text(type['type']['name']),
                    backgroundColor: const Color(0xFFFFE082),
                  );

                }).toList(),
              ),

              const SizedBox(height: 20),

              // INFORMACIÓN
              const Text(
                'Características',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  _infoCard(
                    'Altura',
                    '${pokemon['height'] / 10} m',
                  ),

                  _infoCard(
                    'Peso',
                    '${pokemon['weight'] / 10} kg',
                  ),

                ],
              ),

              const SizedBox(height: 20),

              // HABILIDADES
              const Text(
                'Habilidades',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              ...abilities.map((ability) {

                return ListTile(
                  leading: const Icon(
                    Icons.star,
                    color: Colors.orange,
                  ),
                  title: Text(
                    ability['ability']['name'],
                  ),
                );

              }),

              const SizedBox(height: 15),

              // ESTADÍSTICAS
              const Text(
                'Estadísticas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              ...stats.map((stat) {

                final value = stat['base_stat'] as int;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      '${stat['stat']['name']}: $value',
                    ),

                    const SizedBox(height: 5),

                    LinearProgressIndicator(
                      value: value.clamp(0, 100) / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      color: const Color(0xFF3564A8),
                    ),

                    const SizedBox(height: 12),
                  ],
                );

              }),

            ],
          ),
        ),
      ),
    );
  }

  // WIDGET PERSONALIZADO DE INFORMACIÓN
  Widget _infoCard(String title, String value) {

    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF7),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        children: [

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(value),
        ],
      ),
    );
  }
}
