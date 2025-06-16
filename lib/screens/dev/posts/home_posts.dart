import 'package:bucaramovil/controllers/db_firebase_dev.dart';
import 'package:bucaramovil/screens/components/appbar_theme.dart';
import 'package:flutter/material.dart';

class HomePostPage extends StatefulWidget {
  const HomePostPage({super.key});

  @override
  State<HomePostPage> createState() => _HomePostPageState();
}

class _HomePostPageState extends State<HomePostPage> {
  late Future<List<Map<String, dynamic>>> _peopleFuture;

  @override
  void initState() {
    super.initState();
    _peopleFuture = getPosts();
  }

  Future<void> _refreshData() async {
    setState(() {
      _peopleFuture = getPosts();
    });
  }

  Color getColorFromSeverity(String severity) {
    switch (severity.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.yellow;
      case 'green':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Home de Posts"),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _peopleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final posts = snapshot.data ?? [];

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: EdgeInsets.all(8),
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    // Navegar a la página de detalles con los datos del post
                    Navigator.pushNamed(
                      context,
                      '/post/details',
                      arguments: post,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post['nombre'] ?? 'Sin nombre',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'UID: ${post['uid'] ?? 'N/A'}',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/posts/add');
          if (result == true) {
            _refreshData();
          }
        },
        tooltip: "Agregar Nombre",
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
