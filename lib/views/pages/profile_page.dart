import 'package:flutter/material.dart';
import 'package:pet_adoption/provider/pet_provider.dart';
import 'package:pet_adoption/views/landing_page.dart';
import 'package:pet_adoption/views/model/pets_model.dart';
import 'package:pet_adoption/views/widgets/pet_detial.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final userId = "user_id"; // Replace with actual user ID fetching logic

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/profilepic.jpg"),
                  radius: 40,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selam",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser?.email ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Pre-Requested Adoption Requests",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: petProvider.fetchAdoptionRequests(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching requests'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No adoption requests found'));
                  } else {
                    final adoptionRequests = snapshot.data!;
                    return ListView.builder(
                      itemCount: adoptionRequests.length,
                      itemBuilder: (context, index) {
                        final request = adoptionRequests[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/dog1b.jpg"),
                            ),
                            title: Text(request['petName']),
                            subtitle: Text("Breed: ${request['petBreed']}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                // Navigate to pet detail
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PetDetail(
                                    pet: PetsModel(
                                      id: request['petId'],
                                      petName: request['petName'],
                                      petBreed: request['petBreed'],
                                      age: 2,
                                      description: request['description'],
                                      price: request['price'],
                                      petImage: request['petImage'],
                                      likes: request['likes'],
                                    ),
                                  ),
                                )
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LandingPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LandingPage(),
                        ),
                      );
                      final pref = await SharedPreferences.getInstance();
                      pref.setBool("showHome", false);
                    },
                    child: const Text("Navigate to Onboarding Screen"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
