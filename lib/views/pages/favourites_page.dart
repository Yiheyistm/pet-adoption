import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pet_adoption/provider/pet_provider.dart';
import 'package:pet_adoption/views/model/pets_model.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourites"),
      ),
      body: Consumer<PetProvider>(
        builder: (context, petProvider, child) {
          print('#################################jj');
          print(petProvider.favoritePets);
          if (petProvider.favoritePets.isEmpty) {
            return const Center(
              child: Text("No favourites added yet."),
            );
          }
          return ListView.builder(
            itemCount: petProvider.favoritePets.length,
            itemBuilder: (context, index) {
              PetsModel pet = petProvider.favoritePets[index];
              return ListTile(
                leading: Image.asset(pet.petImage),
                title: Text(pet.petName),
                subtitle: Text(pet.petBreed),
              );
            },
          );
        },
      ),
    );
  }
}
