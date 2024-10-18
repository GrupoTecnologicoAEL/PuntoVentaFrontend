class Proveedor {
  final int id;
  final String nombre;
  final String? direccion;
  final String? telefono;
  final String? email;
  final String? contacto;
  final String estado;

  Proveedor({
    required this.id,
    required this.nombre,
    this.direccion,
    this.telefono,
    this.email,
    this.contacto,
    required this.estado,
  });

  // Factory para crear una instancia de Proveedor desde un JSON
  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      id: json['id'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      email: json['email'],
      contacto: json['contacto'],
      estado: json['estado'],
    );
  }

  // Método para convertir el Proveedor en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'email': email,
      'contacto': contacto,
      'estado': estado,
    };
  }
}
