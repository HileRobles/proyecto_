class Articulo {
  final int? id;
  final String codigo;
  final String nombre;
  final int cantidad;
  final double precio;
  final String? descripcion;
  final String categoria;
  final String? imagenUrl;

  Articulo({
    this.id,
    required this.codigo,
    required this.nombre,
    this.cantidad = 0,
    this.precio = 0.0,
    this.descripcion,
    this.categoria = 'otro/a',
    this.imagenUrl,
  });

  factory Articulo.fromJson(Map<String, dynamic> json) {
    return Articulo(
      id: json['id'],
      codigo: json['codigo'],
      nombre: json['nombre'],
      cantidad: json['cantidad'] ?? 0,
      precio: (json['precio'] ?? 0.0).toDouble(),
      descripcion: json['descripcion'],
      categoria: json['categoria'] ?? 'otro/a',
      imagenUrl: json['imagen_url'] ?? 'assets/images/no-image.jpeg',
    );
  }

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'nombre': nombre,
        'cantidad': cantidad,
        'precio': precio,
        'descripcion': descripcion,
        'categoria': categoria,
        'imagen_url': imagenUrl,
      };
}