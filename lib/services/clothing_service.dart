
import 'dart:convert';
import 'package:http/http.dart' as http;

class ClothingService {

  final String baseUrl =
      'https://dummyjson.com/products/category/mens-shirts';

  // Obtener productos de ropa
  Future<List<Map<String, dynamic>>> getClothingProducts() async {

    final response = await http.get(
      Uri.parse('$baseUrl?limit=20'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al consultar la ropa');
    }

    final data = jsonDecode(response.body);

    final List products = data['products'];

    return products.map((product) {
      return Map<String, dynamic>.from(product);
    }).toList();
  }
}
