import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    // Check if user is already logged in
    if (_authService.isLoggedIn) {
      await loadCurrentUser();
    }
    
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) {
      if (user == null) {
        _currentUser = null;
      } else {
        loadCurrentUser();
      }
      notifyListeners();
    });
  }

  Future<void> loadCurrentUser() async {
    _currentUser = await _authService.getCurrentUserData();
    notifyListeners();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? address,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentUser = await _authService.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
        address: address,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentUser = await _authService.signIn(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.updateProfile(
        name: name,
        phone: phone,
        address: address,
      );

      // Reload user data
      await loadCurrentUser();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.resetPassword(email);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}