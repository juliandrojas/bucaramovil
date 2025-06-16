import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
// Función para obtener una colección de documentos
Future<List> getCollection() async {
  // Inicializa una lista para almacenar los documentos
  List post = [];
  try {
    CollectionReference collection = db.collection('post');
    QuerySnapshot queryPost = await collection.get();
    for (var doc in queryPost.docs) {
      post.add(doc.data());
    }
  } catch (e) {
    print("Error al obtener la colección: $e");
  }
  return post;
}

Future<void> addExamplePost() async {
  try {
    // Colección "posts" en Firestore
    final CollectionReference postsCollection = FirebaseFirestore.instance
        .collection('posts');

    // Datos de ejemplo que se insertarán
    final Map<String, dynamic> examplePost = {
      'userId': 'V4FHtR18FlMB03dt2OG2OnJ3Y693',
      'description': 'Gran afluencia de personas en Plaza Principal.',
      'imageUrl': 'https://example.com/image.jpg',
      'location': {'latitude': 7.1234, 'longitude': -73.1234},
      'severity': 'red',
      'comments': [
        {
          'userId': 'user123',
          'userName': 'Usuario Anónimo',
          'commentText': 'Muy ocupado el lugar.',
          'timestamp': FieldValue.serverTimestamp(),
        },
        {
          'userId': 'user456',
          'userName': 'Otro Usuario',
          'commentText': 'Se necesita más seguridad.',
          'timestamp': FieldValue.serverTimestamp(),
        },
      ],
      'createdAt': FieldValue.serverTimestamp(),
    };

    // Insertar el documento en Firestore
    await postsCollection.add(examplePost);

    print("✅ Post de ejemplo insertado exitosamente.");
  } catch (e) {
    print("❌ Error al insertar el post de ejemplo: $e");
    rethrow;
  }
}

// Función para obtener una colección de documentos
Future<List> getPosts() async {
  // Inicializa una lista para almacenar los documentos
  List people = [];
  try {
    CollectionReference collection = db.collection('people');
    QuerySnapshot queryPost = await collection.get();
    for (var doc in queryPost.docs) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Agrega el UID del documento a los datos
      final person = {
        "name": data['name'],
        "uid": doc.id, // Agrega el UID del documento
      };
      people.add(person);
    }
  } catch (e) {
    print("Error al obtener la colección: $e");
  }
  //await Future.delayed(const Duration(seconds: 4));
  return people;
}

// Función para agregar un documento a la colección 'people'
Future<void> addPeople(String name) async {
  // Guardamos la información
  await db.collection('people').add({'name': name});
}

// Función para actualizar un documento en la colección 'people'
Future<void> updatePeople(String uid, String name) async {
  await db.collection('people').doc(uid).set({'name': name});
}

// Función para eliminar un documento de la colección 'people'
Future<void> deletePeople(String uid) async {
  await db.collection('people').doc(uid).delete();
}
