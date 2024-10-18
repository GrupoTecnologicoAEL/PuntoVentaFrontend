import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/detalle-orden-compra.dart';
import '../../../services/detalle_orden_compra.dart';  // Asegúrate de importar tu servicio correctamente

class DetalleOrdenCompraScreen extends StatefulWidget {
  final int ordenId;

  DetalleOrdenCompraScreen({required this.ordenId});

  @override
  _DetalleOrdenCompraScreenState createState() => _DetalleOrdenCompraScreenState();
}

class _DetalleOrdenCompraScreenState extends State<DetalleOrdenCompraScreen> {
  final OrdenCompraService _ordenCompraService = OrdenCompraService();
  late Future<List<DetalleOrdenCompra>> _detallesOrdenCompra;

  @override
  void initState() {
    super.initState();
    // Asignamos el futuro con el método del servicio
    _detallesOrdenCompra = _ordenCompraService.getDetallesOrdenCompra(widget.ordenId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Orden #${widget.ordenId}'),
      ),
      body: FutureBuilder<List<DetalleOrdenCompra>>(
        future: _detallesOrdenCompra,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron detalles de la orden'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final detalle = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text('Producto: ${detalle.nombreProducto}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cantidad: ${detalle.cantidad}'),
                        Text('Precio Compra: Q${detalle.precioCompra.toStringAsFixed(2)}'),
                        Text('Subtotal: Q${detalle.subtotal.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
