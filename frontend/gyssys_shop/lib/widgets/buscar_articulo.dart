import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/articulo.dart';
import '../providers/articulo_provider.dart';
import 'producto_card.dart';

class BuscarArticulo extends StatefulWidget {
  const BuscarArticulo({Key? key}) : super(key: key);

  @override
  _BuscarArticuloState createState() => _BuscarArticuloState();
}

class _BuscarArticuloState extends State<BuscarArticulo> {
  final _searchController = TextEditingController();
  List<Articulo> _resultados = [];
  bool _buscando = false;
  String? _error;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _buscarProductos() async {
    final query = _searchController.text.trim();
    
    if (query.isEmpty) {
      setState(() {
        _error = 'Ingrese un nombre o código para buscar';
        _resultados = [];
      });
      return;
    }

    setState(() {
      _buscando = true;
      _resultados = [];
      _error = null;
    });

    try {
      final resultados = await Provider.of<ArticuloProvider>(context, listen: false)
          .buscar(query);
      
      setState(() => _resultados = resultados);
    } catch (e) {
      setState(() => _error = "Error al buscar: ${e.toString()}");
    } finally {
      setState(() => _buscando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Productos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Buscar por nombre o código',
                    suffixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (_) => _buscarProductos(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _buscarProductos,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('BUSCAR'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buscando
                ? const Center(child: CircularProgressIndicator())
                : _resultados.isEmpty
                    ? Center(
                        child: Text(
                          _error ?? 'No se encontraron resultados',
                          style: TextStyle(
                            color: _error != null ? Colors.red : Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _resultados.length,
                        itemBuilder: (context, index) => ProductoCard(
                          articulo: _resultados[index],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}