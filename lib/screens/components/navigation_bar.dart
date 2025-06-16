import 'package:bucaramovil/screens/home.dart';
import 'package:bucaramovil/screens/dev/maps/home_map.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavigationBarHome extends StatefulWidget {
  final User? user;
  const NavigationBarHome({required this.user, super.key});

  @override
  State<NavigationBarHome> createState() => _NavigationBarHomeState();
}

class _NavigationBarHomeState extends State<NavigationBarHome> {
  int _selectedIndex = 0;

  // Lista de páginas asociadas a cada ícono
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [PostsHomePage(user: widget.user), const HomeMapPage()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType
            .fixed, // Mantiene los íconos fijos sin animación de shifting
      ),
    );
  }
}
