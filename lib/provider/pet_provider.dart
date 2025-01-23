import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption/views/model/pets_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PetProvider with ChangeNotifier {
  List<PetsModel> _favoritePets = [];

  List<PetsModel> get favoritePets => _favoritePets;

  void toggleFavorite(PetsModel pet, bool isfav) async {
    if (isfav) {
      _favoritePets.remove(pet);
    } else {
      _favoritePets.add(pet);
    }
    notifyListeners();
    print('@@@@@@@@@@@@@@@@@@');
    print(favoritePets);
    await _saveFavorites();
  }

  PetsModel? findPetById(int id) {
    return allPets.firstWhere((pet) => pet.id == id);
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? favoritePetsString = prefs.getString('favoritePets');
    if (favoritePetsString != null) {
      List<dynamic> favoritePetsJson = json.decode(favoritePetsString);
      _favoritePets =
          favoritePetsJson.map((json) => PetsModel.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoritePetsJson =
        _favoritePets.map((pet) => json.encode(pet.toJson())).toList();
    await prefs.setString('favoritePets', json.encode(favoritePetsJson));
  }

  Future<void> saveAdoptionRequest(
      String userName, String phoneNO, String email, PetsModel pet) async {
    try {
      CollectionReference adoptions =
          FirebaseFirestore.instance.collection('adoptions');
      await adoptions.add({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'userName': userName,
        'phoneNO': phoneNO,
        'email': email,
        'petId': pet.id,
        'petName': pet.petName,
        'petBreed': pet.petBreed,
        'adoptionDate': Timestamp.now(),
      });
      print('Adoption request saved successfully');
    } catch (e) {
      print('Failed to save adoption request: $e');
    }
  }

Stream<List<Map<String, dynamic>>> fetchAdoptionRequests() {
    try {
      // Get the current user ID
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the 'adoptions' collection
      CollectionReference adoptions =
          FirebaseFirestore.instance.collection('adoptions');

      // Return a stream of adoption requests filtered by the current user's ID
      return adoptions
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      });
    } catch (e) {
      print('Failed to fetch adoption requests: $e');
      // Return an empty stream in case of an error
      return Stream.value([]);
    }
  }
}
