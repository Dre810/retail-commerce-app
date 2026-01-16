import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;

  // Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? address,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      UserModel user = UserModel(
        uid: credential.user!.uid,
        email: email,
        name: name,
        role: 'customer', // Default role
        phone: phone,
        address: address,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(user.toMap());

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'An error occurred. Please try again.';
    }
  }

  // Sign in with email and password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user data from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }

      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'An error occurred. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user data
  Future<UserModel?> getCurrentUserData() async {
    if (_auth.currentUser == null) return null;

    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    try {
      if (_auth.currentUser == null) return;

      Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (address != null) updates['address'] = address;

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update(updates);
    } catch (e) {
      throw 'Failed to update profile. Please try again.';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'Failed to send reset email. Please try again.';
    }
  }

  // Error handler
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}