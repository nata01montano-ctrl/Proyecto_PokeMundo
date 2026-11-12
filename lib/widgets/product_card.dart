
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final String pokemonName;
  final Color pokemonColor;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.pokemonName,
    required this.pokemonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String image = product['thumbnail'] ?? '';

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
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF4F4F4),
                child: image.isNotEmpty
                    ? Image.network(
                        image,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.checkroom,
                            size: 65,
                            color: Colors.grey,
                          );
                        },
                      )
                    : const Icon(Icons.checkroom, size: 65),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: pokemonColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      pokemonName,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['title'] ?? 'Producto Pokémon',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'US\$ ${product['price'] ?? '0'}',
                    style: const TextStyle(
                      color: Color(0xFF3564A8),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
