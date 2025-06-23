import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/articulo_provider.dart';
import 'producto_card.dart';
import 'bottom_navbar.dart';
import '../models/articulo.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _currentIndex = 1;
  String? _selectedCategoria = 'todos';
  final List<String> _categorias = ['todos', 'ropa', 'accesorios', 'cosmeticos', 'calzado', 'otro/a'];

  @override
  void initState() {
    super.initState();
    Provider.of<ArticuloProvider>(context, listen: false).cargarArticulos();
  }

  List<Articulo> _filtrarArticulos(List<Articulo> articulos) {
    if (_selectedCategoria == 'todos') return articulos;
    return articulos.where((a) => a.categoria.toLowerCase() == _selectedCategoria?.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArticuloProvider>(context);
    final articulosFiltrados = _filtrarArticulos(provider.articulos);

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('GYSSYS Shop'),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<String>(
              value: _selectedCategoria,
              items: _categorias.map((categoria) {
                return DropdownMenuItem(
                  value: categoria,
                  child: Text(categoria),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategoria = value);
              },
              decoration: const InputDecoration(
                labelText: 'Filtrar por categoría',
                border: OutlineInputBorder(),
              ),
              isExpanded: true,
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                    ? Center(child: Text(provider.error!))
                    : articulosFiltrados.isEmpty
                        ? const Center(child: Text('No hay productos disponibles'))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: articulosFiltrados.length,
                            itemBuilder: (ctx, i) => ProductoCard(
                              articulo: articulosFiltrados[i],
                            ),
                          ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _navigateToScreen(index, context);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.cargarArticulos(),
        child: const Icon(Icons.refresh),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  void _navigateToScreen(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/buscar');
        break;
      case 1:
        break; 
      case 2:
        Navigator.pushNamed(context, '/agregar');
        break;
      case 3:
        Navigator.pushNamed(context, '/editar-lista');
        break;
    }
  }
}