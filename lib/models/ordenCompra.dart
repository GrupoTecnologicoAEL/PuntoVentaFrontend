class OrdenCompra {
  final int id;
  final int proveedorId;
  final String? nombreProveedor;
  final DateTime? fechaOrden;
  final String estado;
  final double total;

  OrdenCompra({
    required this.id,
    required this.proveedorId,
    required this.nombreProveedor,
    required this.fechaOrden,
    required this.estado,
    required this.total,
  });

 // Factory para crear una instancia de OrdenCompra desde un JSON
factory OrdenCompra.fromJson(Map<String, dynamic> json) {
  DateTime? fechaOrden;
  // Intentamos parsear la fecha si existe en el JSON
  if (json['FechaOrden'] != null) {
    try {
      fechaOrden = DateTime.parse(json['FechaOrden']);
    } catch (e) {
      print('Error al parsear la fecha: $e');
      fechaOrden = null;
    }
  }

  return OrdenCompra(
    id: json['Id'] ?? 0,
    proveedorId: json['ProveedorId'] ?? 0,
    nombreProveedor: json['NombreProveedor'] ?? 'Sin nombre', // Aquí aseguramos que traiga el NombreProveedor
    fechaOrden: fechaOrden,
    estado: json['Estado'] ?? 'Pendiente',
    total: json['Total'] != null ? json['Total'].toDouble() : 0.0,
  );
}

  // Método para convertir la OrdenCompra en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'proveedorId': proveedorId,
      'nombre': nombreProveedor,
      'fechaOrden': fechaOrden?.toIso8601String(),
      'estado': estado,
      'total': total,
    };
  }
}
