import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:watchmelater/firebase_options.dart';

// ...
class FirebaseService {
  static FirebaseFirestore? _firestore;

  static Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    _firestore = FirebaseFirestore.instance;
  }

  static FirebaseFirestore get firestore {
    if (_firestore == null) {
      throw Exception('FirebaseService not initialized. Call init() first.');
    }
    return _firestore!;
  }
}
