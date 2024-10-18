import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/detalle-orden-compra.dart';

class OrdenCompraService {
  Future<List<DetalleOrdenCompra>> getDetallesOrdenCompra(int ordenId) async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/detalles-orden-compra/$ordenId'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DetalleOrdenCompra.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener detalles de la orden');
    }
  }

}
