
import 'package:flutter/material.dart';

import '../services/recipe_service.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class ChefScreen extends StatefulWidget {
  const ChefScreen({super.key});

  @override
  State<ChefScreen> createState() => _ChefScreenState();
}

class _ChefScreenState extends State<ChefScreen> {

  final RecipeService recipeService = RecipeService();

  final TextEditingController searchController =
      TextEditingController();

  late Future<List<Map<String, dynamic>>> recipesFuture;

  @override
  void initState() {
    super.initState();

    // CARGAR RECETAS INICIALES
    recipesFuture = recipeService.searchRecipes('chicken');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // BUSCAR RECETAS
  void searchRecipes(String name) {

    if (name.trim().isEmpty) {
      return;
    }

    setState(() {
      recipesFuture = recipeService.searchRecipes(name.trim());
    });
  }

  // RECARGAR RECETAS
  void loadRecipes() {

    setState(() {
      recipesFuture = recipeService.searchRecipes('chicken');
    });
  }

  // ABRIR DETALLES DE UNA RECETA
  Future<void> openRecipe(String id) async {

    try {

      final recipe = await recipeService.getRecipeDetails(id);

      if (!mounted) return;

      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (context) {
            return RecipeDetailScreen(recipe: recipe);
          },
        ),
      );

    } catch (error) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudieron cargar los detalles'),
        ),
      );
    }
  }

  // RECETA ALEATORIA
  Future<void> randomRecipe() async {

    try {

      final recipe = await recipeService.getRandomRecipe();

      if (!mounted) return;

      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (context) {
            return RecipeDetailScreen(recipe: recipe);
          },
        ),
      );

    } catch (error) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontró una receta aleatoria'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          // PRESENTACIÓN
          const Text(
            '¡Bienvenido a PokéChef!',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Descubre deliciosas recetas para entrenadores Pokémon.',
          ),

          const SizedBox(height: 15),

          // BUSCADOR
          TextField(
            controller: searchController,

            onSubmitted: searchRecipes,

            decoration: InputDecoration(
              hintText: 'Buscar una receta...',
              prefixIcon: const Icon(Icons.search),

              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  searchRecipes(searchController.text);
                },
              ),

              filled: true,
              fillColor: Colors.white,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // BOTÓN ALEATORIO
          SizedBox(
            width: double.infinity,

            child: ElevatedButton.icon(
              onPressed: randomRecipe,

              icon: const Icon(Icons.casino),

              label: const Text(
                '¡Sorpréndeme con una receta!',
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFCB05),
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.all(13),
              ),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Descubre nuevas recetas',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // LISTA DE RECETAS
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: recipesFuture,

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

                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 55,
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'No se pudieron cargar las recetas',
                        ),

                        ElevatedButton(
                          onPressed: loadRecipes,
                          child: const Text('Intentar nuevamente'),
                        ),
                      ],
                    ),
                  );
                }

                final recipes = snapshot.data ?? [];

                // SIN RESULTADOS
                if (recipes.isEmpty) {

                  return const Center(
                    child: Text(
                      'No se encontraron recetas. '
                      'Intenta con otro nombre.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                // MOSTRAR RECETAS
                return GridView.builder(

                  itemCount: recipes.length,

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),

                  itemBuilder: (context, index) {

                    final recipe = recipes[index];

                    return RecipeCard(
                      recipe: recipe,

                      onTap: () {
                        openRecipe(
                          recipe['idMeal'].toString(),
                        );
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
