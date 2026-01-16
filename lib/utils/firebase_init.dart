import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseInitializer {
  static Future<void> initializeSampleData() async {
    final firestore = FirebaseFirestore.instance;
    
    // Check if data already exists
    final productsSnapshot = await firestore.collection('products').limit(1).get();
    
    if (productsSnapshot.docs.isEmpty) {
      await _addSampleProducts(firestore);
      await _addSampleCategories(firestore);
      print('Sample data added to Firebase');
    }
  }

  static Future<void> _addSampleProducts(FirebaseFirestore firestore) async {
    final sampleProducts = [
      {
        'name': 'Apple iPhone 15 Pro',
        'description': 'Latest iPhone with A17 Pro chip, titanium design, and advanced camera system',
        'price': 999.99,
        'originalPrice': 1099.99,
        'imageUrl': 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?q=80&w=2070',
        'rating': 4.8,
        'reviewCount': 324,
        'category': 'Electronics',
        'tags': ['Smartphone', 'Apple', '5G', 'Camera'],
        'isFeatured': true,
        'isPopular': true,
        'stock': 50,
        'colors': ['Space Black', 'White', 'Natural Titanium', 'Blue'],
        'sizes': ['128GB', '256GB', '512GB', '1TB'],
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Sony WH-1000XM5',
        'description': 'Industry-leading noise cancellation wireless headphones',
        'price': 349.99,
        'originalPrice': 399.99,
        'imageUrl': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=2070',
        'rating': 4.7,
        'reviewCount': 189,
        'category': 'Electronics',
        'tags': ['Headphones', 'Wireless', 'Noise Cancelling'],
        'isFeatured': true,
        'isPopular': true,
        'stock': 75,
        'colors': ['Black', 'Silver', 'Blue'],
        'sizes': ['One Size'],
        'createdAt': FieldValue.serverTimestamp(),
      },
      // Add more sample products...
    ];

    for (var product in sampleProducts) {
      await firestore.collection('products').add(product);
    }
  }

  static Future<void> _addSampleCategories(FirebaseFirestore firestore) async {
    final categories = [
      {'name': 'Electronics', 'icon': '📱'},
      {'name': 'Fashion', 'icon': '👕'},
      {'name': 'Home & Kitchen', 'icon': '🏠'},
      {'name': 'Beauty', 'icon': '💄'},
      {'name': 'Sports', 'icon': '⚽'},
      {'name': 'Books', 'icon': '📚'},
      {'name': 'Toys', 'icon': '🧸'},
    ];

    for (var category in categories) {
      await firestore.collection('categories').add(category);
    }
  }

  static Future<void> createAdminUser() async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;
      
      // Check if admin already exists
      const adminEmail = 'admin@retailcommerce.com';
      const adminPassword = 'Admin123!';
      
      try {
        await auth.createUserWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
        
        // Add admin user to Firestore
        await firestore.collection('users').doc(auth.currentUser!.uid).set({
          'uid': auth.currentUser!.uid,
          'email': adminEmail,
          'name': 'Administrator',
          'role': 'admin',
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        print('Admin user created successfully');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          print('Admin user already exists');
        } else {
          print('Error creating admin user: ${e.message}');
        }
      }
    } catch (e) {
      print('Error in createAdminUser: $e');
    }
  }
}