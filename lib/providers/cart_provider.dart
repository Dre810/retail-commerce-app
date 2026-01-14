import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  
  List<CartItem> get items => _items;
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
  
  void addItem(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    
    if (index >= 0) {
      // Item already in cart, increase quantity
      _items[index].quantity++;
    } else {
      // Add new item to cart
      _items.add(CartItem(product: product));
    }
    
    notifyListeners();
    
    // Show snackbar (we'll need context for this, so we'll handle it in the UI)
  }
  
  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }
  
  void increaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }
  
  void decreaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }
  
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
  
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }
  
  int getQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(product: Product(
        id: '',
        name: '',
        description: '',
        price: 0,
        imageUrl: '',
        rating: 0,
        category: '',
        stock: 0,
      ), quantity: 0),
    );
    return item.quantity;
  }
}