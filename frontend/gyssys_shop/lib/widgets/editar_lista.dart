import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/articulo.dart';
import '../providers/articulo_provider.dart';

class EditarListaScreen extends StatefulWidget {
  const EditarListaScreen({Key? key}) : super(key: key);

  @override
  _EditarListaScreenState createState() => _EditarListaScreenState();
}

class _EditarListaScreenState extends State<EditarListaScreen> {
  String _selectedCategoria = 'todos';
  final List<String> _categorias = ['todos', 'ropa', 'accesorios', 'cosmeticos', 'calzado', 'otro/a'];

  List<Articulo> _filtrarArticulos(List<Articulo> articulos) {
    if (_selectedCategoria == 'todos') return articulos;
    return articulos.where((a) => a.categoria.toLowerCase() == _selectedCategoria.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArticuloProvider>(context);
    final articulosFiltrados = _filtrarArticulos(provider.articulos);

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Editar Productos'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.cargarArticulos(),
          ),
        ],
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
                setState(() => _selectedCategoria = value!);
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
                : articulosFiltrados.isEmpty
                    ? const Center(child: Text('No hay productos para editar'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: articulosFiltrados.length,
                        itemBuilder: (ctx, index) {
                          final articulo = articulosFiltrados[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            child: ListTile(
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      articulo.imagenUrl ?? 'assets/images/no-image.jpeg',
                                    ),
                                    fit: BoxFit.cover,
                                    onError: (_, __) => Image.asset(
                                      'assets/images/no-image.jpeg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                articulo.nombre,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Código: ${articulo.codigo}'),
                                  Text(
                                    '\$${articulo.precio.toStringAsFixed(2)} - ${articulo.categoria}',
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/editar',
                                  arguments: articulo,
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.cargarArticulos(),
        child: const Icon(Icons.refresh),
        backgroundColor: Colors.grey[800],
      ),
    );
  }
}