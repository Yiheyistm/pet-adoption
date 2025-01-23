import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_adoption/provider/pet_provider.dart';
import 'package:pet_adoption/views/model/pets_model.dart';
import 'package:provider/provider.dart';

class AdoptionPage extends StatefulWidget {
  final PetsModel pet;

  const AdoptionPage({super.key, required this.pet});

  @override
  _AdoptionPageState createState() => _AdoptionPageState();
}

class _AdoptionPageState extends State<AdoptionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopt ${widget.pet.petName}'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(widget.pet.petImage,
                        height: 200, width: 200, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Save adoption request to Firestore
                        await _firestore.collection('adoptions').add({
                          'userId': FirebaseAuth.instance.currentUser!.uid,
                          'petId': widget.pet.id,
                          'petName': widget.pet.petName,
                          'petBreed': widget.pet.petBreed,
                          'petImage': widget.pet.petImage,
                          'userName': _nameController.text,
                          'email': _emailController.text,
                          'phoneNO': _phoneController.text,
                          'adoptionDate': FieldValue.serverTimestamp(),
                        });

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Adoption request submitted!')),
                        );

                        // Navigate back
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
