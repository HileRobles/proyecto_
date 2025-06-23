import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/articulo.dart';
import '../providers/articulo_provider.dart';
import 'dart:io';

class EditarArticulo extends StatefulWidget {
  final Articulo articulo;

  const EditarArticulo({Key? key, required this.articulo}) : super(key: key);

  @override
  _EditarArticuloState createState() => _EditarArticuloState();
}

class _EditarArticuloState extends State<EditarArticulo> {
  late final TextEditingController _codigoController;
  late final TextEditingController _nombreController;
  late final TextEditingController _cantidadController;
  late final TextEditingController _precioController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _categoriaController;
  final List<String> _categorias = ['ropa', 'accesorios', 'cosmeticos', 'calzado', 'otro/a'];
  File? _imagen;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _codigoController = TextEditingController(text: widget.articulo.codigo);
    _nombreController = TextEditingController(text: widget.articulo.nombre);
    _cantidadController = TextEditingController(text: widget.articulo.cantidad.toString());
    _precioController = TextEditingController(text: widget.articulo.precio.toStringAsFixed(2));
    _descripcionController = TextEditingController(text: widget.articulo.descripcion ?? '');
    _categoriaController = TextEditingController(text: widget.articulo.categoria);
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imagen = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArticuloProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Editar Producto'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.cargarArticulos(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _seleccionarImagen,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  image: DecorationImage(
                    image: _imagen != null
                        ? FileImage(_imagen!) as ImageProvider
                        : NetworkImage(widget.articulo.imagenUrl ?? 'assets/images/no-image.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: Colors.grey[300]),
                      Text('Cambiar imagen', style: TextStyle(color: Colors.grey[300])),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _codigoController,
              decoration: const InputDecoration(labelText: 'Código'),
            ),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: _cantidadController,
              decoration: const InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _precioController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            DropdownButtonFormField<String>(
              value: _categoriaController.text,
              items: _categorias.map((categoria) {
                return DropdownMenuItem(
                  value: categoria,
                  child: Text(categoria),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _categoriaController.text = value!);
              },
              decoration: const InputDecoration(
                labelText: 'Categoría',
              ),
            ),
            TextFormField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _guardarCambios,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('GUARDAR CAMBIOS'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.cargarArticulos(),
        child: const Icon(Icons.refresh),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  Future<void> _guardarCambios() async {
    setState(() => _isSaving = true);
    
    final articuloActualizado = Articulo(
      id: widget.articulo.id,
      codigo: _codigoController.text,
      nombre: _nombreController.text,
      cantidad: int.tryParse(_cantidadController.text) ?? 0,
      precio: double.tryParse(_precioController.text) ?? 0.0,
      descripcion: _descripcionController.text.isEmpty ? null : _descripcionController.text,
      categoria: _categoriaController.text,
      imagenUrl: widget.articulo.imagenUrl,
    );

    final success = await Provider.of<ArticuloProvider>(context, listen: false)
        .actualizarArticulo(articuloActualizado, _imagen);

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar cambios')),
        );
      }
    }
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _nombreController.dispose();
    _cantidadController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    _categoriaController.dispose();
    super.dispose();
  }
}