
import 'package:flutter/material.dart';

class PokemonCard extends StatelessWidget {

  final Map<String, dynamic> pokemon;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
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

    return Card(
      elevation: 3,
      color: const Color(0xFFE9EEF7),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(18),

        child: Padding(
          padding: const EdgeInsets.all(10),

          child: Column(
            children: [

              // BOTÓN FAVORITOS
              Align(
                alignment: Alignment.topRight,

                child: IconButton(
                  onPressed: onFavorite,

                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,

                    color: Colors.red,
                  ),
                ),
              ),

              // IMAGEN
              Expanded(
                child: Image.network(
                  image ?? '',
                  fit: BoxFit.contain,

                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.catching_pokemon,
                      size: 60,
                    );
                  },
                ),
              ),

              // NÚMERO
              Text(
                '#${id.toString().padLeft(3, '0')}',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              // NOMBRE
              Text(
                name.toUpperCase(),

                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              // TIPOS
              Wrap(
                alignment: WrapAlignment.center,

                children: types.map((type) {

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                    ),

                    child: Chip(
                      label: Text(
                        type['type']['name'],
                        style: const TextStyle(fontSize: 10),
                      ),

                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    ),
                  );

                }).toList(),
              ),

              const Text(
                'Ver detalles',

                style: TextStyle(
                  color: Color(0xFF3564A8),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
