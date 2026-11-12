
import 'package:flutter/material.dart';

import '../services/clothing_service.dart';
import '../widgets/product_card.dart';

class StyleScreen extends StatefulWidget {
  const StyleScreen({super.key});

  @override
  State<StyleScreen> createState() => _StyleScreenState();
}

class _StyleScreenState extends State<StyleScreen> {

  final ClothingService clothingService = ClothingService();

  late Future<List<Map<String, dynamic>>> productsFuture;

  String searchText = '';

  // Pokémon que utilizaremos como inspiración visual
  final List<Map<String, dynamic>> inspirations = [
    {
      'name': 'Pikachu',
      'color': const Color(0xFFFFCB05),
    },
    {
      'name': 'Charmander',
      'color': Colors.orange,
    },
    {
      'name': 'Squirtle',
      'color': Colors.lightBlue,
    },
    {
      'name': 'Bulbasaur',
      'color': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();

    productsFuture = clothingService.getClothingProducts();
  }

  // Recargar productos
  void loadProducts() {
    setState(() {
      productsFuture = clothingService.getClothingProducts();
    });
  }

  // Mostrar detalles del producto
  void showProductDetails(
    Map<String, dynamic> product,
    String pokemonName,
  ) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      builder: (context) {

        return Padding(
          padding: const EdgeInsets.all(20),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Image.network(
                    product['thumbnail'],
                    height: 190,
                    fit: BoxFit.contain,

                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.checkroom,
                        size: 100,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  product['title'] ?? 'Producto',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'US\$ ${product['price']}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF3564A8),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  product['description'] ?? '',
                  style: const TextStyle(fontSize: 15),
                ),

                const SizedBox(height: 15),

                Text(
                  'Inspiración: $pokemonName',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  'Valoración: ${product['rating'] ?? 'Sin datos'} / 5',
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text('Cerrar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
            '¡Encuentra tu estilo Pokémon!',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Descubre prendas inspiradas en tus Pokémon favoritos.',
          ),

          const SizedBox(height: 15),

          // BUSCADOR
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar prendas...',
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

          const SizedBox(height: 15),

          // CATÁLOGO
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: productsFuture,

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
                          size: 55,
                          color: Colors.red,
                        ),

                        const Text(
                          'No se pudieron cargar los productos',
                        ),

                        ElevatedButton(
                          onPressed: loadProducts,
                          child: const Text('Intentar nuevamente'),
                        ),
                      ],
                    ),
                  );
                }

                final products = snapshot.data ?? [];

                // BUSCAR PRODUCTOS
                final filteredProducts = products.where((product) {

                  final name = product['title']
                      .toString()
                      .toLowerCase();

                  return name.contains(searchText);

                }).toList();

                if (filteredProducts.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron productos'),
                  );
                }

                // MOSTRAR CATÁLOGO
                return GridView.builder(

                  itemCount: filteredProducts.length,

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.62,
                  ),

                  itemBuilder: (context, index) {

                    final product = filteredProducts[index];

                    // Asignación visual de inspiración Pokémon
                    final inspiration =
                        inspirations[index % inspirations.length];

                    return ProductCard(
                      product: product,

                      pokemonName: inspiration['name'] as String,

                      pokemonColor: inspiration['color'] as Color,

                      onTap: () {
                        showProductDetails(
                          product,
                          inspiration['name'] as String,
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
