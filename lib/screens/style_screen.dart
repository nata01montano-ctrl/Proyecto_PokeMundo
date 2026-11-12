
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

  @override
  void initState() {
    super.initState();
    productsFuture = clothingService.getClothingProducts();
  }

  // Volver a consultar los productos
  void loadProducts() {
    setState(() {
      productsFuture = clothingService.getClothingProducts();
    });
  }

  // Mostrar información del producto seleccionado
  void showProductDetails(
    Map<String, dynamic> product,
    String pokemonName,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product['title'] ?? 'Producto Pokémon'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if ((product['thumbnail'] ?? '').toString().isNotEmpty)
                  Image.network(
                    product['thumbnail'],
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.checkroom,
                        size: 80,
                        color: Colors.grey,
                      );
                    },
                  ),
                const SizedBox(height: 15),

                Text(
                  'Relacionado con: $pokemonName',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3564A8),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  product['description']?.toString().isNotEmpty == true
                      ? product['description']
                      : 'Este producto no tiene descripción disponible.',
                ),

                const SizedBox(height: 15),

                Text(
                  'Precio: US\$ ${product['price'] ?? '0'}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3564A8),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Identificar el Pokémon relacionado con el producto
  Map<String, dynamic> identifyPokemon(
    Map<String, dynamic> product,
  ) {
    final title = (product['title'] ?? '').toString().toLowerCase();
    final description =
        (product['description'] ?? '').toString().toLowerCase();

    final productText = '$title $description';

    if (productText.contains('pikachu')) {
      return {
        'name': 'Pikachu',
        'color': const Color(0xFFFFCB05),
      };
    } else if (productText.contains('charmander') ||
        productText.contains('charizard')) {
      return {
        'name': 'Charmander / Charizard',
        'color': Colors.orange,
      };
    } else if (productText.contains('squirtle')) {
      return {
        'name': 'Squirtle',
        'color': Colors.lightBlue,
      };
    } else if (productText.contains('bulbasaur')) {
      return {
        'name': 'Bulbasaur',
        'color': Colors.green,
      };
    } else if (productText.contains('eevee')) {
      return {
        'name': 'Eevee',
        'color': Colors.brown,
      };
    }

    return {
      'name': 'Pokémon',
      'color': Colors.blue,
    };
  }

  
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Descubre productos inspirados en el mundo Pokémon.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),

        // Buscador de productos
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar productos Pokémon...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchText = value.toLowerCase();
              });
            },
          ),
        ),

        const SizedBox(height: 15),

        // Lista de productos
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Error al cargar los productos'),
                      ElevatedButton(
                        onPressed: loadProducts,
                        child: const Text('Intentar nuevamente'),
                      ),
                    ],
                  ),
                );
              }

              final products = snapshot.data ?? [];

              final filteredProducts = products.where((product) {
                final title =
                    (product['title'] ?? '').toString().toLowerCase();
                final description =
                    (product['description'] ?? '').toString().toLowerCase();

                return title.contains(searchText) ||
                    description.contains(searchText);
              }).toList();

              if (filteredProducts.isEmpty) {
                return const Center(
                  child: Text('No se encontraron productos.'),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  final pokemon = identifyPokemon(product);

                  final pokemonName = pokemon['name'] as String;
                  final pokemonColor = pokemon['color'] as Color;

                  return ProductCard(
                    product: product,
                    pokemonName: pokemonName,
                    pokemonColor: pokemonColor,
                    onTap: () {
                      showProductDetails(product, pokemonName);
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