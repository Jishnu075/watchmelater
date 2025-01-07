import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:watchmelater/core/services/firebase_remoteconfig_service.dart';
import 'package:watchmelater/firebase_options.dart';

// ...
class FirebaseService {
  static FirebaseFirestore? _firestore;

  static Future<void> init() async {
    await Firebase.initializeApp(
        name: 'watchmelater-28cf2',
        options: DefaultFirebaseOptions.currentPlatform);
    _firestore = FirebaseFirestore.instance;
    await FirebaseRemoteconfigService.instance.initialize();
  }

  static FirebaseFirestore get firestore {
    if (_firestore == null) {
      throw Exception('FirebaseService not initialized. Call init() first.');
    }
    return _firestore!;
  }
}
