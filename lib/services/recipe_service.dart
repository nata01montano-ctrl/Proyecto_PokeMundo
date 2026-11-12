
import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeService {

  final String baseUrl =
      'https://www.themealdb.com/api/json/v1/1';

  // BUSCAR RECETAS POR NOMBRE
  Future<List<Map<String, dynamic>>> searchRecipes(
      String name) async {

    final response = await http.get(
      Uri.parse('$baseUrl/search.php?s=$name'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al consultar las recetas');
    }

    final data = jsonDecode(response.body);

    // Si no hay resultados
    if (data['meals'] == null) {
      return [];
    }

    final List meals = data['meals'];

    return meals.map((meal) {
      return Map<String, dynamic>.from(meal);
    }).toList();
  }

  // CONSULTAR DETALLES DE UNA RECETA
  Future<Map<String, dynamic>> getRecipeDetails(
      String id) async {

    final response = await http.get(
      Uri.parse('$baseUrl/lookup.php?i=$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al consultar los detalles');
    }

    final data = jsonDecode(response.body);

    if (data['meals'] == null || data['meals'].isEmpty) {
      throw Exception('Receta no encontrada');
    }

    return Map<String, dynamic>.from(
      data['meals'][0],
    );
  }

  // OBTENER UNA RECETA ALEATORIA
  Future<Map<String, dynamic>> getRandomRecipe() async {

    final response = await http.get(
      Uri.parse('$baseUrl/random.php'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al buscar receta aleatoria');
    }

    final data = jsonDecode(response.body);

    if (data['meals'] == null || data['meals'].isEmpty) {
      throw Exception('No se encontró ninguna receta');
    }

    return Map<String, dynamic>.from(
      data['meals'][0],
    );
  }
}
