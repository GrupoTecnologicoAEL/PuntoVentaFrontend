class Producto {
  final int id;
  final String nombre;
  final int categoriaId;
  final double precioCompra;
  final double precioVenta;
  final int stock;
  final String? descripcion;

  Producto({
    required this.id,
    required this.nombre,
    required this.categoriaId,
    required this.precioCompra,
    required this.precioVenta,
    required this.stock,
    this.descripcion,
  });

  // Factory para crear una instancia de Producto desde un JSON
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      categoriaId: json['categoriaId'],
      precioCompra: json['precioCompra'].toDouble(),
      precioVenta: json['precioVenta'].toDouble(),
      stock: json['stock'],
      descripcion: json['descripcion'],
    );
  }

  // Método para convertir el Producto en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'categoriaId': categoriaId,
      'precioCompra': precioCompra,
      'precioVenta': precioVenta,
      'stock': stock,
      'descripcion': descripcion,
    };
  }
}
