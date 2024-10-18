import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../provider_login.dart' as supAuth;
import '../singUp.dart';
import '../admins/ordenesCompras/form_purchase_order.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userPermissions;
  bool isLoading = true; // Bandera para mostrar un indicador de carga
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserPermissions();
  }

  // Cargar permisos del usuario desde Firestore
  Future<void> _loadUserPermissions() async {
    final supAuth.AuthProvider authProvider = supAuth.AuthProvider();
    final User? user = authProvider.currentUser;

    if (user != null) {
      try {
        final doc = await _firestore.collection('Users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data();
          List<String> permissions = List<String>.from(data?['permissions'] ?? []);
          setState(() {
            userPermissions = {
              'role': data?['role'],
              'permissions': permissions,
            };
            userName = data?['name'];
            userEmail = data?['email'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No se encontraron permisos para el usuario.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar los permisos del usuario: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      context.go('/login'); // Si no está autenticado, redirigir al login
    }
  }

  // Método para cerrar sesión y redirigir al login
  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    context.go('/login');
  }

  // Método para verificar si el usuario tiene un permiso
  bool _hasPermission(String permission) {
    if (userPermissions == null) return false;
    final List<String> permissions = userPermissions?['permissions'] ?? [];
    return permissions.contains(permission);
  }

  @override
  Widget build(BuildContext context) {
    // Calculamos el tamaño de la pantalla para ajustar la cantidad de columnas
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2; // Default para pantallas pequeñas

    // Ajustar el número de columnas según el ancho de pantalla
    if (screenWidth >= 1200) {
      crossAxisCount = 4; // Pantallas grandes
    } else if (screenWidth >= 800) {
      crossAxisCount = 3; // Pantallas medianas (tabletas)
    }

    return Scaffold(
  appBar: AppBar(
    title: Text(
      'Bienvenido, ${userName ?? 'Usuario'}',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.black,
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            userEmail ?? '',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
      IconButton(
        icon: Icon(Icons.logout),
        onPressed: () => _logout(context),
        color: Colors.white,
      ),
    ],
  ),
  drawer: Drawer(
    child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(userName ?? 'Usuario'),
          accountEmail: Text(userEmail ?? 'Correo no disponible'),
          currentAccountPicture: CircleAvatar(
            child: Icon(Icons.person),
          ),
        ),
        if (_hasPermission('ver_dashboard'))
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
            },
          ),
        if (_hasPermission('gestionar_clientes'))
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Clientes'),
            onTap: () {
              // Acción para gestión de clientes
            },
          ),
        if (_hasPermission('gestionar_productos'))
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('Gestión de Productos'),
            onTap: () {
              // Acción para gestión de productos
            },
          ),
        if (_hasPermission('gestionar_existencias'))
          ListTile(
            leading: Icon(Icons.inventory),
            title: Text('Gestión de Existencias'),
            onTap: () {
              // Acción para gestión de existencias
            },
          ),
        if (_hasPermission('ver_reportes'))
          ListTile(
            leading: Icon(Icons.report),
            title: Text('Reportes'),
            onTap: () {
              // Acción para ver reportes
            },
          ),
        if (_hasPermission('gestionar_inventario'))
          ListTile(
            leading: Icon(Icons.inventory),
            title: Text('gestionar_inventario'),
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrdenCompraScreen()),
            );
            },
          ),
          if (_hasPermission('acceder_configuraciones'))
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            onTap: () {
              // Acción para configuración
            },
          ),
      ],
    ),
  ),
  body: isLoading
      ? Center(child: CircularProgressIndicator())
      : userPermissions == null
          ? Center(child: Text('No se pudieron cargar los permisos.'))
          : _buildAdminModules(context, crossAxisCount),
  );
}
  Widget _buildAdminModules(BuildContext context, int crossAxisCount) {
    final role = userPermissions?['role'] ?? 'Usuario';

    if (userPermissions?['permissions'].isEmpty ?? true) {
      return Center(child: Text('No tienes permisos asignados.'));
    }

    final modules = [
      if (_hasPermission('gestionar_inventario'))
        _buildModuleCard(
          context,
          title: 'Gestionar Inventario',
          icon: Icons.inventory_2_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrdenCompraScreen()),
            );
          },
          backgroundColor: Colors.teal,
        ),
      if (_hasPermission('ver_reportes'))
        _buildModuleCard(
          context,
          title: 'Ver Reportes',
          icon: Icons.bar_chart,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          backgroundColor: Colors.purple,
        ),
      if (_hasPermission('ver_reportes_inventario'))
        _buildModuleCard(
          context,
          title: 'Ver Reportes Inventario',
          icon: Icons.bar_chart,
          onTap: () {
            
          },
          backgroundColor: Colors.red,
        ),
      if (_hasPermission('gestionar_usuarios'))
        _buildModuleCard(
          context,
          title: 'Gestionar Usuarios',
          icon: Icons.people_alt_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          backgroundColor: Colors.blue,
        ),
    ];

    if (modules.isEmpty) {
      return Center(child: Text('No tienes acceso a ningún módulo.'));
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      padding: const EdgeInsets.all(16),
      children: modules,
    );
  }

  // Método para construir las tarjetas de cada módulo del panel de administración
  // Método para construir las tarjetas de cada módulo del panel de administración
Widget _buildModuleCard(
    BuildContext context, {
      required String title,
      required IconData icon,
      required VoidCallback onTap,
      required Color backgroundColor, // Agregamos un parámetro para el color de fondo
    }) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      shadowColor: backgroundColor.withOpacity(0.5), // Usamos el color del fondo para el shadow
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor, // Color de fondo personalizado
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withOpacity(0.3), // Color del fondo del icono
              child: Icon(icon, size: 50, color: Colors.white), // Color del icono
            ),
            SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}
