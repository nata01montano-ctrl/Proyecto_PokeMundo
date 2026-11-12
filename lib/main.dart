
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/pokedex_screen.dart';
import 'screens/style_screen.dart';
import 'screens/chef_screen.dart';

void main() {
  runApp(const PokeMundoApp());
}

class PokeMundoApp extends StatelessWidget {
  const PokeMundoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PokéMundo',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFCB05),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFBF2),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFCB05),
          foregroundColor: Color(0xFF292929),
          centerTitle: true,
        ),
      ),

      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  int selectedIndex = 0;

  final List<Widget> screens = const [
  SizedBox.shrink(),
  PokedexScreen(),
  StyleScreen(),
  ChefScreen(),
];

  final List<String> titles = [
    'PokéMundo',
    'Pokédex',
    'PokéStyle',
    'PokéChef',
  ];

  void changeScreen(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          titles[selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: selectedIndex == 0
    ? HomeScreen(onNavigate: changeScreen)
    : screens[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: changeScreen,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3564A8),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.catching_pokemon),
            label: 'Pokédex',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom),
            label: 'Moda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Recetas',
          ),
        ],
      ),
    );
  }
}
