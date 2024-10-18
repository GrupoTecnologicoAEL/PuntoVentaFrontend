import 'package:flutter/material.dart';
import '../../../models/ordenCompra.dart';
import '../../../services/ordenes_compra.dart';
import 'package:intl/intl.dart';
import '../ordenesCompras/detalle_orden_compra.dart';

class OrdenCompraScreen extends StatefulWidget {
  @override
  _OrdenCompraScreenState createState() => _OrdenCompraScreenState();
}

class _OrdenCompraScreenState extends State<OrdenCompraScreen> {
  final OrdenCompraService _ordenCompraService = OrdenCompraService();
  late Future<List<OrdenCompra>> _ordenesCompra;

  @override
  void initState() {
    super.initState();
    _ordenesCompra = _ordenCompraService.getOrdenCompra();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Órdenes de Compra', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal[700],
        actions: [
          IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              // Implementa la acción para agregar una nueva orden de compra
            },
            color: Colors.white,
          )
        ],
      ),
      body: FutureBuilder<List<OrdenCompra>>(
        future: _ordenesCompra,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron órdenes de compra'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 30.0,
                  dataRowHeight: 60,  // Ajustado para ser más compacto
                  headingRowHeight: 50,  // Altura reducida para los encabezados
                  columns: [
                    DataColumn(
                      label: Text(
                        'ID',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.teal[900]),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Proveedor ID',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.teal[900]),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Nombre Proveedor',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.teal[900]),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Fecha',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.teal[900]),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Estado',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.teal[900]),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Total',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.teal[900]),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Acciones',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.teal[900]),
                      ),
                    ),
                  ],
                  rows: snapshot.data!.map((orden) {
                    // Formateamos la fecha
                    String fechaFormateada = 'Fecha no disponible';
                    if (orden.fechaOrden != null) {
                      fechaFormateada = DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(orden.fechaOrden!);
                    }

                    // Verificamos si nombreProveedor está disponible
                    String nombreProveedor = orden.nombreProveedor ?? 'Sin nombre';

                    return DataRow(
                      cells: [
                        DataCell(Text(orden.id.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(orden.proveedorId.toString(),
                            style: TextStyle(color: Colors.teal[800]))),
                        DataCell(Text(nombreProveedor,
                            style: TextStyle(fontWeight: FontWeight.w500))),
                        DataCell(Text(fechaFormateada,
                            style: TextStyle(color: Colors.grey[700]))),
                        DataCell(Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 8.0),  // Más compacto
                          decoration: BoxDecoration(
                            color: orden.estado == 'Pendiente'
                                ? Colors.orangeAccent
                                : Colors.greenAccent,
                            borderRadius: BorderRadius.circular(10),  // Radio ajustado
                          ),
                          child: Text(
                            orden.estado,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )),
                        DataCell(Text('Q${orden.total.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Colors.teal[900],
                                fontWeight: FontWeight.w600))),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.visibility, color: Colors.blue, size: 20),  // Tamaño ajustado
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetalleOrdenCompraScreen(
                                          ordenId: orden.id),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.green, size: 20),  // Tamaño ajustado
                                onPressed: () {
                                  // Acción de editar
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red, size: 20),  // Tamaño ajustado
                                onPressed: () {
                                  // Acción de eliminar
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected))
                          return Colors.teal.withOpacity(0.2);
                        return null;  // Usa el valor predeterminado.
                      }),
                    );
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  DashboardItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
