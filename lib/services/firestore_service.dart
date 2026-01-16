import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/product_model.dart';
import '../models/cart_item.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Products Collection
  CollectionReference get _productsCollection =>
      _firestore.collection('products');

  // Categories Collection
  CollectionReference get _categoriesCollection =>
      _firestore.collection('categories');

  // Users Collection
  CollectionReference get _usersCollection => _firestore.collection('users');

  // Orders Collection
  CollectionReference get _ordersCollection => _firestore.collection('orders');

  // ========== PRODUCT OPERATIONS ==========

  // Get all products
  Stream<List<Product>> getProducts() {
    return _productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
      }).toList();
    });
  }

  // Get featured products
  Stream<List<Product>> getFeaturedProducts() {
    return _productsCollection
        .where('isFeatured', isEqualTo: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
      }).toList();
    });
  }

  // Get popular products
  Stream<List<Product>> getPopularProducts() {
    return _productsCollection
        .where('isPopular', isEqualTo: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
      }).toList();
    });
  }

  // Get products by category
  Stream<List<Product>> getProductsByCategory(String category) {
    return _productsCollection
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
      }).toList();
    });
  }

  // Get single product
  Future<Product?> getProduct(String productId) async {
    try {
      final doc = await _productsCollection.doc(productId).get();
      if (doc.exists) {
        return Product.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Search products
  Stream<List<Product>> searchProducts(String query) {
    return _productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
      }).where((product) {
        final searchLower = query.toLowerCase();
        return product.name.toLowerCase().contains(searchLower) ||
            product.description.toLowerCase().contains(searchLower) ||
            product.category.toLowerCase().contains(searchLower) ||
            product.tags.any((tag) => tag.toLowerCase().contains(searchLower));
      }).toList();
    });
  }

  // ========== CATEGORY OPERATIONS ==========

  // Get all categories
  Stream<List<String>> getCategories() {
    return _categoriesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  // ========== CART OPERATIONS ==========

  // Save user's cart to Firestore
  Future<void> saveCart(String userId, List<CartItem> cartItems) async {
    try {
      final cartData = cartItems.map((item) => item.toJson()).toList();
      await _usersCollection.doc(userId).update({
        'cart': cartData,
        'cartUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to save cart. Please try again.';
    }
  }

// Load user's cart from Firestore
Future<List<CartItem>> loadCart(String userId) async {
  try {
    final doc = await _usersCollection.doc(userId).get();
    
    if (!doc.exists) {
      return [];
    }
    
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null || !data.containsKey('cart')) {
      return [];
    }
    
    final cartData = data['cart'];
    if (cartData == null || cartData is! List) {
      return [];
    }
    
    final List<CartItem> cartItems = [];
    
    for (final item in cartData) {
      if (item is Map<String, dynamic>) {
        try {
          final cartItem = CartItem.fromJson(item);
          cartItems.add(cartItem);
        } catch (e) {
          print('Error parsing cart item: $e');
          continue;
        }
      }
    }
    
    return cartItems;
  } catch (e) {
    print('Error loading cart from Firestore: $e');
    return [];
  }
}

  // ========== ORDER OPERATIONS ==========

  // Create new order
  Future<void> createOrder({
    required String userId,
    required List<CartItem> items,
    required double totalAmount,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    try {
      final orderId = _ordersCollection.doc().id;
      
      await _ordersCollection.doc(orderId).set({
        'id': orderId,
        'userId': userId,
        'items': items.map((item) => item.toJson()).toList(),
        'totalAmount': totalAmount,
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
        'status': 'pending', // pending, processing, shipped, delivered, cancelled
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Clear user's cart after successful order
      await _usersCollection.doc(userId).update({
        'cart': [],
        'cartUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to create order. Please try again.';
    }
  }

  // Get user's orders
  Stream<List<Map<String, dynamic>>> getUserOrders(String userId) {
    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {...doc.data() as Map<String, dynamic>, 'id': doc.id};
      }).toList();
    });
  }

  // ========== ADMIN OPERATIONS ==========

  // Add new product (admin only)
  Future<void> addProduct(Product product) async {
    try {
      await _productsCollection.add(product.toJson());
    } catch (e) {
      throw 'Failed to add product. Please try again.';
    }
  }

  // Update product (admin only)
  Future<void> updateProduct(String productId, Product product) async {
    try {
      await _productsCollection.doc(productId).update(product.toJson());
    } catch (e) {
      throw 'Failed to update product. Please try again.';
    }
  }

  // Delete product (admin only)
  Future<void> deleteProduct(String productId) async {
    try {
      await _productsCollection.doc(productId).delete();
    } catch (e) {
      throw 'Failed to delete product. Please try again.';
    }
  }

  // Simple image upload method for web
  Future<String> uploadProductImage(String imageUrl, String productId) async {
    try {
      // For web demo, we'll just return the URL
      // In production, implement proper upload
      return imageUrl;
    } catch (e) {
      return imageUrl; // Fallback
    }
  }

  // Get all users (admin only)
  Stream<List<Map<String, dynamic>>> getAllUsers() {
    return _usersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {...doc.data() as Map<String, dynamic>, 'id': doc.id};
      }).toList();
    });
  }

  // Get all orders (admin only)
  Stream<List<Map<String, dynamic>>> getAllOrders() {
    return _ordersCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {...doc.data() as Map<String, dynamic>, 'id': doc.id};
      }).toList();
    });
  }
}