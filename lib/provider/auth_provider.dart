import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? _errorMessage;

  User? get user => _user;
  String? get errorMessage => _errorMessage;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      _errorMessage = null;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    }
  }

  Future<void> signUpWithEmailAndPassword(
      String userName, String email, String password) async {
    print('########################2');
    print(email);
    print(password);
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      print('########################3');
      _user = userCredential.user;
      print(_user);
      storeUserData(userName, _user!.uid, email);
      _errorMessage = null;
     
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _errorMessage = null;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    }
  }

  Future<void> storeUserData(String userName, String uid, String email) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'userName': userName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        // Process the data as needed
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Example: print user email
        print(data['email']);
      } else {
        _errorMessage = 'User data not found';
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
