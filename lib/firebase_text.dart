import 'package:firebase_core/firebase_core.dart';

Future<void> testFirebase() async {
  try {
    print('Testing Firebase initialization...');
    
    // For web, we need to use JavaScript configuration
    // First, let's see if we can initialize without options
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "YOUR_API_KEY",
        authDomain: "YOUR_AUTH_DOMAIN",
        projectId: "YOUR_PROJECT_ID",
        storageBucket: "YOUR_STORAGE_BUCKET",
        messagingSenderId: "YOUR_SENDER_ID",
        appId: "YOUR_APP_ID",
      ),
    );
    
    print('Firebase initialized successfully!');
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
}