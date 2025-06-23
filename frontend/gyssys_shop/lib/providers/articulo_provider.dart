import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/articulo.dart';

class ArticuloProvider with ChangeNotifier {
  final String _baseUrl = dotenv.get('API_URL', fallback: 'http://10.0.2.2:3000/api');
  List<Articulo> _articulos = [];
  bool _isLoading = false;
  String? _error;

  List<Articulo> get articulos => _articulos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarArticulos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/articulos'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _articulos = data.map((json) => Articulo.fromJson(json)).toList();
        _error = null;
      } else {
        _error = "Error al cargar: ${response.statusCode}";
      }
    } catch (e) {
      _error = "Error de conexión: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> guardarArticulo(Articulo articulo, XFile? imagenFile) async {
    _isLoading = true;
    notifyListeners();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/articulos'),
      );

      request.fields.addAll({
        'codigo': articulo.codigo,
        'nombre': articulo.nombre,
        'cantidad': articulo.cantidad.toString(),
        'precio': articulo.precio.toString(),
        'descripcion': articulo.descripcion ?? '',
        'categoria': articulo.categoria,
      });

      if (imagenFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('imagen', imagenFile.path),
        );
      }

      final response = await request.send();
      
      if (response.statusCode == 201) {
        await cargarArticulos();
        return true;
      }
      return false;
    } catch (e) {
      _error = "Error al guardar: ${e.toString()}";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> actualizarArticulo(Articulo articulo, File? imagenFile) async {
    _isLoading = true;
    notifyListeners();

    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$_baseUrl/articulos/${articulo.id}'),
      );

      request.fields.addAll({
        'codigo': articulo.codigo,
        'nombre': articulo.nombre,
        'cantidad': articulo.cantidad.toString(),
        'precio': articulo.precio.toString(),
        'descripcion': articulo.descripcion ?? '',
        'categoria': articulo.categoria,
      });

      if (imagenFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('imagen', imagenFile.path),
        );
      }

      final response = await request.send();
      
      if (response.statusCode == 200) {
        await cargarArticulos();
        return true;
      }
      return false;
    } catch (e) {
      _error = "Error al actualizar: ${e.toString()}";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> eliminarArticulo(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/articulos/$id'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        await cargarArticulos();
        return true;
      }
      return false;
    } catch (e) {
      _error = "Error al eliminar: ${e.toString()}";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

Future<List<Articulo>> buscar(String query) async {
  try {
    final uri = Uri.parse('$_baseUrl/articulos/buscar')
      .replace(queryParameters: {
        'q': query,
      });

    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 10));
    
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((json) => Articulo.fromJson(json))
          .toList();
    }
    return [];
  } catch (e) {
    _error = "Error al buscar: ${e.toString()}";
    return [];
  }
}
}