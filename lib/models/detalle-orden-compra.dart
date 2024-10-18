class DetalleOrdenCompra {
  final int productoId;
  final String nombreProducto;
  final int cantidad;
  final double precioCompra;
  final double subtotal;

  DetalleOrdenCompra({
    required this.productoId,
    required this.nombreProducto,
    required this.cantidad,
    required this.precioCompra,
    required this.subtotal,
  });

  factory DetalleOrdenCompra.fromJson(Map<String, dynamic> json) {
    return DetalleOrdenCompra(
      productoId: json['ProductoId'] ?? 0,
      nombreProducto: json['NombreProducto'] ?? '',
      cantidad: json['Cantidad'] ?? 0,
      precioCompra: json['PrecioCompra'] != null ? json['PrecioCompra'].toDouble() : 0.0,
      subtotal: json['Subtotal'] != null ? json['Subtotal'].toDouble() : 0.0,
    );
  }
}
