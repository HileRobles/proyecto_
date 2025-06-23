import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'widgets/inicio.dart';
import 'widgets/agregar_articulo.dart';
import 'widgets/editar_articulo.dart';
import 'widgets/detalle_articulo.dart';
import 'widgets/editar_lista.dart';
import 'widgets/buscar_articulo.dart';
import 'models/articulo.dart';
import 'providers/articulo_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ArticuloProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GYSSYS Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey[800]!,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          iconTheme: const IconThemeData(color: Colors.grey),
          elevation: 0,
        ),
      ),
      routes: {
        '/home': (context) => const Inicio(),
        '/agregar': (context) => const AgregarArticulo(),
        '/buscar': (context) => const BuscarArticulo(),
        '/editar-lista': (context) => const EditarListaScreen(),
        '/editar': (context) {
          final articulo = ModalRoute.of(context)!.settings.arguments as Articulo;
          return EditarArticulo(articulo: articulo);
        },
        '/detalle': (context) {
          final articulo = ModalRoute.of(context)!.settings.arguments as Articulo;
          return DetalleArticulo(articulo: articulo);
        },
      },
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'GYSSYS SHOP',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Provider.of<ArticuloProvider>(context, listen: false).cargarArticulos();
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'ENTRAR',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}