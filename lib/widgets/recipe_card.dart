
import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {

  final Map<String, dynamic> recipe;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 3,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: InkWell(
        onTap: onTap,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // IMAGEN DE LA RECETA
            Expanded(
              child: Image.network(
                recipe['strMealThumb'] ?? '',
                width: double.infinity,
                fit: BoxFit.cover,

                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 60,
                    ),
                  );
                },
              ),
            ),

            // INFORMACIÓN DE LA RECETA
            Padding(
              padding: const EdgeInsets.all(10),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    recipe['strMeal'] ?? 'Receta',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    recipe['strCategory'] ?? 'Comida',
                    style: const TextStyle(
                      color: Color(0xFF3564A8),
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Row(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: 15,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Ver receta',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
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
