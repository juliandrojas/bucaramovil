import 'package:bucaramovil/controllers/auth.dart';
import 'package:bucaramovil/screens/components/appbar_theme.dart';
import 'package:flutter/material.dart';

class LoginPageDev extends StatelessWidget {
  const LoginPageDev({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Login - Entorno de Desarrollo'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.withOpacity(0.3), width: 0.5),
            ),
            child: Container(
              padding: const EdgeInsets.all(32),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_circle_rounded,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Bienvenido a BucaraMóvil',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _GoogleSignInButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Separar el botón en su propio widget mejora la legibilidad y reutilización
class _GoogleSignInButton extends StatefulWidget {
  @override
  __GoogleSignInButtonState createState() => __GoogleSignInButtonState();
}

class __GoogleSignInButtonState extends State<_GoogleSignInButton> {
  bool _isLoading = false;

  Future<void> _handleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await signInWithGoogle();

      if (userCredential != null) {
        // Inicio de sesión exitoso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bienvenido ${userCredential.user?.displayName}'),
          ),
        );
        // Aquí puedes navegar a otra pantalla
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Usuario canceló el login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inicio de sesión cancelado')),
        );
      }
    } catch (e) {
      // Manejo de errores generales
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al iniciar sesión: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _handleSignIn,
      icon: _isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Icon(Icons.login),
      label: Text(
        _isLoading ? 'Iniciando sesión...' : 'Iniciar sesión con Google',
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(double.infinity, 0),
      ),
    );
  }
}
