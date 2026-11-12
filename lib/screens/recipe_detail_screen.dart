
import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {

  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {

    // OBTENER LOS INGREDIENTES
    final List<Map<String, String>> ingredients = [];

    for (int i = 1; i <= 20; i++) {

      final ingredient = recipe['strIngredient$i']
          ?.toString()
          .trim() ?? '';

      final measure = recipe['strMeasure$i']
          ?.toString()
          .trim() ?? '';

      if (ingredient.isNotEmpty) {
        ingredients.add({
          'ingredient': ingredient,
          'measure': measure,
        });
      }
    }

    return Scaffold(

      appBar: AppBar(
        title: const Text('Detalle de receta'),
      ),

      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // FOTOGRAFÍA
            Image.network(
              recipe['strMealThumb'] ?? '',
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 200,
                  child: Center(
                    child: Icon(Icons.restaurant, size: 70),
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // NOMBRE
                  Text(
                    recipe['strMeal'] ?? 'Receta',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // CATEGORÍA
                  Text(
                    'Categoría: ${recipe['strCategory'] ?? 'No disponible'}',
                  ),

                  const SizedBox(height: 5),

                  // ORIGEN
                  Text(
                    'Origen: ${recipe['strArea'] ?? 'No disponible'}',
                  ),

                  const SizedBox(height: 25),

                  // INGREDIENTES
                  const Text(
                    'Ingredientes',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  for (final item in ingredients)

                    ListTile(
                      leading: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),

                      title: Text(item['ingredient']!),

                      subtitle: Text(item['measure']!),
                    ),

                  const SizedBox(height: 20),

                  // PREPARACIÓN
                  const Text(
                    'Preparación',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    recipe['strInstructions'] ??
                        'No hay instrucciones disponibles.',
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 25),

                  // BOTÓN
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      icon: const Icon(Icons.arrow_back),

                      label: const Text('Volver a PokéChef'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
