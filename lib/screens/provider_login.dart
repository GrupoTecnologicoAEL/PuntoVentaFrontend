import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../screens/singUp.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isSigningIn = false;

  final Map<String, List<String>> rolesPermissions = {
    'Gerente': [
      'gestionar_inventario',
      'ver_reportes',
      'gestionar_usuarios',
      'procesar_pedidos',
      'ver_pedidos',
      'acceder_configuraciones'
    ],
    'Cajero': [
      'procesar_pedidos',
      'ver_inventario',
      'emitir_recibos',
      'gestionar_pagos'
    ],
    'Inventario': [
      'gestionar_inventario',
      'actualizar_existencias',
      'ver_reportes_inventario'
    ]
  };

  User? get currentUser => _auth.currentUser;

  Future<Map<String, dynamic>?> getUserPermissions(User user) async {
    final doc = await _firestore.collection('Users').doc(user.uid).get();
    
    if (doc.exists) {
      return doc.data();
    } else {
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Correo de restablecimiento de contraseña enviado a $email");
    } catch (error) {
      print("Error al enviar el correo de restablecimiento de contraseña: $error");
      throw error;
    }
  }


  Future<void> signUp({
    required BuildContext context,
    required String name,
    required String address,
    required String contact,
    required String email,
    required String password,
    String role = 'Cajero', 
  }) async {
    try {
      print('Intentando registrar al usuario con el rol: $role');
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = credential.user;

      if (user != null) {

        List<String> permissions = rolesPermissions[role] ?? ['procesar_pedidos'];

        await _firestore.collection('Users').doc(user.uid).set({
          'name': name,
          'address': address,
          'contact': contact,
          'email': email,
          'role': role,
          'permissions': permissions,
        });

        print('Usuario registrado con éxito con el rol: $role');
        context.go('/home');
        notifyListeners();
      }
    } catch (error) {
      print("Error en el registro: $error");
      throw error;
    }
  }

  Future<String> signIn(BuildContext context, String email, String password) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = credential.user;

      if (user != null) {
        final userPermissions = await getUserPermissions(user);
        if (userPermissions != null) {
          final permissions = userPermissions['permissions'];

          // Redirigir basado en los permisos
          if (permissions.contains('gestionar_inventario')) {
            context.go('/home');
          } else if (permissions.contains('procesar_pedidos')) {
            context.go('/home');
          } else {
            context.go('/restricted_access'); 
          }
        }
        notifyListeners();
        return "Inicio de sesión exitoso";
      } else {
        return "El usuario no existe, debe registrarse";
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        return "No se encontró un usuario con ese correo electrónico";
      } else if (error.code == 'wrong-password') {
        return "Contraseña incorrecta";
      } else {
        return "Error en el inicio de sesión";
      }
    } catch (error) {
      print("Error en el inicio de sesión");
      return "Error desconocido, inténtelo de nuevo más tarde";
    }
  }
}