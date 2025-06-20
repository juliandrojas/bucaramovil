import 'package:bucaramovil/screens/components/appbar_theme.dart';
import 'package:bucaramovil/screens/maps/home_map.dart';
import 'package:bucaramovil/screens/profile.dart';
import 'package:bucaramovil/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _paginaActual = 0;

  late List<Widget> _paginas;

  @override
  void initState() {
    super.initState();
    // Inicializamos las páginas aquí para tener acceso al user
    final User? user = FirebaseAuth.instance.currentUser;
    String? nombreUsuario = user?.displayName;

    _paginas = [
      StartPage(),
      HomeMapPage(),
      ProfilePage(nombre: nombreUsuario ?? 'Usuario anónimo'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'BucaraMóvil'),
      body: _paginas[_paginaActual],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _paginaActual = index;
          });
        },
        currentIndex: _paginaActual,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Mapa'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
