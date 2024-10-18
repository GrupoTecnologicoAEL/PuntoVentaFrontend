import 'package:flutter/material.dart';
import '../screens/provider_login.dart' as supAuth;
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  String? _selectedRole;

  List<String> roles = ['Gerente', 'Cajero', 'Inventario'];

  @override
  void initState() {
    super.initState();
    _checkAdminAccess();
  }

  // Verifica si el usuario actual es un administrador antes de permitir el acceso a la pantalla
  void _checkAdminAccess() async {
    final authProvider = supAuth.AuthProvider();
    final user = authProvider.currentUser;

    if (user != null) {
      final userPermissions = await authProvider.getUserPermissions(user);
      if (userPermissions != null && userPermissions['role'] != 'Gerente') {
        context.go('/home');
      }
    } else {
      context.go('/login');
    }
  }

  void _handleSignUp(supAuth.AuthProvider authProvider) async {
    print('Intentando registrar al usuario');
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final contact = _contactController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || address.isEmpty || contact.isEmpty || email.isEmpty || password.isEmpty || _selectedRole == null) {
      setState(() {
        _errorMessage = 'Por favor, complete todos los campos y seleccione un rol';
      });
      return;
    }

    try {
      await authProvider.signUp(
        context: context,
        name: name,
        address: address,
        contact: contact,
        email: email,
        password: password,
        role: _selectedRole!,
      );

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Usuario creado correctamente.'),
          backgroundColor: Colors.green,
        ),
      );

      // Limpiar los campos después del registro exitoso
      _clearTextFields();

      // Redirigir al login
      GoRouter.of(context).go('/login');
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  void _clearTextFields() {
    _nameController.clear();
    _addressController.clear();
    _contactController.clear();
    _emailController.clear();
    _passwordController.clear();
    setState(() {
      _selectedRole = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = supAuth.AuthProvider();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crear Cuenta',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_errorMessage.isNotEmpty)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                _buildTextField(_nameController, 'Nombre Completo', Icons.person),
                SizedBox(height: 16),
                _buildTextField(_addressController, 'Dirección', Icons.home),
                SizedBox(height: 16),
                _buildTextField(_contactController, 'Contacto', Icons.phone),
                SizedBox(height: 16),
                _buildTextField(_emailController, 'Email', Icons.email),
                SizedBox(height: 16),
                _buildTextField(_passwordController, 'Contraseña', Icons.lock, isPassword: true),
                SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Selecciona un rol',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.blueAccent.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  dropdownColor: Colors.blue.shade100,
                  style: TextStyle(color: Colors.black),
                  items: roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role, style: TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                ),
                SizedBox(height: 30),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blueGrey,
                  ),
                  onPressed: () => _handleSignUp(authProvider),
                  child: Text(
                    'Crear Cuenta',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.blueAccent.withOpacity(0.2),
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Colors.black),
      obscureText: isPassword,
    );
  }
}
