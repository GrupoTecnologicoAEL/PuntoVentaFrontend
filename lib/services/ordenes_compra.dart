import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ordenCompra.dart';

class OrdenCompraService {
  final String apiUrl = 'http://localhost:3000/api/orden-compra/';

  Future<List<OrdenCompra>> getOrdenCompra() async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    print(response.body);  // Imprime la respuesta cruda aquí
    List<dynamic> body = json.decode(response.body);
    List<OrdenCompra> ordencompra =
        body.map((dynamic item) => OrdenCompra.fromJson(item)).toList();
    return ordencompra;
  } else {
    throw Exception('Fail to load orders');
  }
}


}
