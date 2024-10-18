import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Importaciones de las pantallas necesarias para la navegación
import '../screens/login.dart';
import '../screens/admins/admin.dart';
import '../screens/singUp.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<bool> _checkUserRole(String role) async {
  final User? user = _auth.currentUser;
  if (user != null) {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
    return userDoc['role'] == role;
  }
  return false;
}

final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (BuildContext context, GoRouterState state) async {
    final bool isLoggedIn = _auth.currentUser != null;
    final String location = state.uri.toString(); 

    // Redirigir si ya está logueado e intenta acceder al login
    if (isLoggedIn && location == '/login') {
      final bool isAdmin = await _checkUserRole('admin');
      return isAdmin ? '/admin' : '/home';  // Redirige a home en lugar de client
    }

    // Ruta de login
    if (!isLoggedIn && location != '/login') {
      return '/login';
    }

    // Ruta de admin protegida
    if (location.startsWith('/admin')) {
      final bool isAdmin = await _checkUserRole('admin');
      if (!isAdmin) {
        return '/home';  // Redirige a home si no es admin
      }
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => DashboardScreen(), 
    ),
    GoRoute(
      path: '/usuarios',
      builder: (context, state) => SignUpScreen(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => LoginScreen(),
    ),
  ],
);


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Papeleria',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
