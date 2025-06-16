import 'package:bucaramovil/controllers/db_firebase_test.dart';
import 'package:bucaramovil/screens/components/appbar_theme.dart';
import 'package:flutter/material.dart';

class HomeTestPage extends StatefulWidget {
  const HomeTestPage({super.key});

  @override
  State<HomeTestPage> createState() => _HomeTestPageState();
}

class _HomeTestPageState extends State<HomeTestPage> {
  late Future<List> _peopleFuture;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Sección Home de Test"),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder(
          future: _peopleFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  return Card(
                    child: Dismissible(
                      onDismissed: (direction) async {
                        await deletePeople(snapshot.data?[index]['uid']);
                        snapshot.data?.removeAt(index);
                      },
                      confirmDismiss: (direction) async {
                        bool result = false;
                        result = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "¿Está seguro de eliminar a ${snapshot.data?[index]['name']}?",
                              ),
                              content: const Text(
                                "Esta acción no se puede deshacer.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    return Navigator.pop(context, false);
                                  },
                                  child: const Text(
                                    "Cancelar",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    return Navigator.pop(context, true);
                                  },
                                  child: const Text("Si, estoy seguro"),
                                ),
                              ],
                            );
                          },
                        );
                        return result;
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      direction: DismissDirection.startToEnd,
                      key: Key(snapshot.data?[index]['uid']),
                      child: ListTile(
                        onLongPress: () => debugPrint("Borrar"),
                        title: Text(
                          snapshot.data?[index]['name'],
                          style: TextStyle(fontSize: 24),
                        ),
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            '/test/edit',
                            arguments: {
                              "name": snapshot.data?[index]['name'],
                              "uid": snapshot.data?[index]['uid'],
                            },
                          );
                          setState(() {
                            _refreshData();
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      "Cargando...",
                      style: TextStyle(fontSize: 24, color: Colors.blue),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/test/add');
          if (result == true) {
            _refreshData();
          }
        },
        tooltip: "Agregar Nombre",
        child: Icon(Icons.add),
      ),
    );
  }
}
