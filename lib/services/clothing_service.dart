
import 'dart:convert';
import 'package:http/http.dart' as http;

class ClothingService {
  final String baseUrl =
      'https://shopalgoritmo.com/products.json';

  // Obtener productos de la tienda Pokémon
  Future<List<Map<String, dynamic>>> getClothingProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl?limit=50&page=1'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al consultar la tienda Pokémon');
    }

    final data = jsonDecode(response.body);
    final List products = data['products'];

    // Filtrar productos relacionados con Pokémon
    final pokemonProducts = products.where((product) {
      final title = (product['title'] ?? '').toString().toLowerCase();
      final description =
          (product['body_html'] ?? '').toString().toLowerCase();
      final tags = (product['tags'] ?? '').toString().toLowerCase();

      final text = '$title $description $tags';

      return text.contains('pokemon') ||
          text.contains('pikachu') ||
          text.contains('charizard') ||
          text.contains('eevee') ||
          text.contains('bulbasaur') ||
          text.contains('squirtle') ||
          text.contains('charmander');
    }).toList();

    return pokemonProducts.map((product) {
      final variants = product['variants'] as List? ?? [];
      final images = product['images'] as List? ?? [];

      final image = images.isNotEmpty
          ? images[0]['src'] ?? ''
          : '';

      final price = variants.isNotEmpty
          ? variants[0]['price'] ?? '0'
          : '0';

      final description = (product['body_html'] ?? '')
          .toString()
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .trim();

      return {
        'id': product['id'],
        'title': product['title'] ?? 'Producto Pokémon',
        'thumbnail': image,
        'price': price,
        'description': description,
        'rating': null,
        'url': product['handle'] ?? '',
      };
    }).toList();
  }
}
