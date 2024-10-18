import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> initializeFirebase() async {
  // Inicializar Firebase con las variables de entorno del archivo .env
  FirebaseApp app = await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['API_KEY'] ?? 'default_api_key', 
      authDomain: dotenv.env['AUTH_DOMAIN'] ?? 'default_auth_domain',
      projectId: dotenv.env['PROJECT_ID'] ?? 'default_project_id',
      storageBucket: dotenv.env['STORAGE_BUCKET'] ?? 'default_storage_bucket',
      messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? 'default_sender_id',
      appId: dotenv.env['APP_ID'] ?? 'default_app_id',
      measurementId: dotenv.env['MEASUREMENT_ID'] ?? 'default_measurement_id',
    ),
  );

  // Inicializar Firebase Analytics si lo estás usando
  FirebaseAnalytics analytics = FirebaseAnalytics.instanceFor(app: app);
}
