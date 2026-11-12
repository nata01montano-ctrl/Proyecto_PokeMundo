
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigate;

  const HomeScreen({
    super.key,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Bienvenida
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFFFCB05),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '¡Bienvenido a PokéMundo!',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  'Explora Pokémon, descubre nuevos estilos '
                  'y encuentra deliciosas recetas.',
                  style: TextStyle(fontSize: 15),
                ),

                SizedBox(height: 15),

                Center(
                  child: Icon(
                    Icons.catching_pokemon,
                    size: 85,
                    color: Color(0xFF3564A8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Explora nuestras secciones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          sectionCard(
            context,
            'Pokédex',
            'Descubre diferentes Pokémon',
            Icons.catching_pokemon,
            const Color(0xFFE4EEFF),
            1,
          ),

          sectionCard(
            context,
            'PokéStyle',
            'Encuentra ropa inspirada en Pokémon',
            Icons.checkroom,
            const Color(0xFFFFE8D8),
            2,
          ),

          sectionCard(
            context,
            'PokéChef',
            'Descubre recetas deliciosas',
            Icons.restaurant,
            const Color(0xFFFFF1C9),
            3,
          ),
        ],
      ),
    );
  }

  Widget sectionCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    int index,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,

      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.black87),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(description),

        trailing: const Icon(Icons.arrow_forward_ios),

        onTap: () {
          onNavigate?.call(index);
        },
      ),
    );
  }
}
