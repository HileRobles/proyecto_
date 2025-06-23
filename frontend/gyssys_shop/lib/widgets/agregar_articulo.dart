import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/articulo.dart';
import '../providers/articulo_provider.dart';
import 'dart:io';

class AgregarArticulo extends StatefulWidget {
  const AgregarArticulo({Key? key}) : super(key: key);

  @override
  _AgregarArticuloState createState() => _AgregarArticuloState();
}

class _AgregarArticuloState extends State<AgregarArticulo> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  final _nombreController = TextEditingController();
  final _cantidadController = TextEditingController(text: '0');
  final _precioController = TextEditingController(text: '0.0');
  final _descripcionController = TextEditingController();
  final _categoriaController = TextEditingController(text: 'otro/a');
  final List<String> _categorias = ['ropa', 'accesorios', 'cosmeticos', 'calzado', 'otro/a'];
  File? _imagen;
  bool _isSaving = false;

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imagen = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Agregar Producto'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => Provider.of<ArticuloProvider>(context, listen: false).cargarArticulos(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _seleccionarImagen,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    image: _imagen != null
                        ? DecorationImage(
                            image: FileImage(_imagen!),
                            fit: BoxFit.cover,
                          )
                        : const DecorationImage(
                            image: AssetImage(''),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: _imagen == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 40),
                              Text('Agregar imagen'),
                            ],
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(labelText: 'Código'),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _cantidadController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
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
                onPressed: _isSaving ? null : _guardarArticulo,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : const Text('GUARDAR PRODUCTO'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Provider.of<ArticuloProvider>(context, listen: false).cargarArticulos(),
        child: const Icon(Icons.refresh),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  Future<void> _guardarArticulo() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      final nuevoArticulo = Articulo(
        codigo: _codigoController.text,
        nombre: _nombreController.text,
        cantidad: int.parse(_cantidadController.text),
        precio: double.parse(_precioController.text),
        descripcion: _descripcionController.text.isEmpty ? null : _descripcionController.text,
        categoria: _categoriaController.text,
      );

      final success = await Provider.of<ArticuloProvider>(context, listen: false)
          .guardarArticulo(nuevoArticulo, _imagen != null ? XFile(_imagen!.path) : null);

      if (mounted) {
        setState(() => _isSaving = false);
        if (success) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                Provider.of<ArticuloProvider>(context, listen: false).error ?? 'Error al guardar',
              ),
            ),
          );
        }
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