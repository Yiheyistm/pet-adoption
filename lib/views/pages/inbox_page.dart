import 'package:flutter/material.dart';
import 'package:pet_adoption/views/model/pets_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<PetsModel> _filteredPets = [];

  @override
  void initState() {
    super.initState();
    // _filteredPets = allPets;
    _searchController.addListener(_filterPets);
  }

  void _filterPets() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPets = allPets.where((pet) {
        return pet.petName.toLowerCase().contains(query) ||
            pet.petBreed.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Search",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredPets.length,
                itemBuilder: (context, index) {
                  final pet = _filteredPets[index];
                  return ListTile(
                    leading: Image.asset(pet.petImage),
                    title: Text(pet.petName),
                    subtitle: Text(pet.petBreed),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
