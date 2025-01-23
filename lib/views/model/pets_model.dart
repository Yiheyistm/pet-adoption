class PetsModel {
  final int id;
  final String petName;
  final String petImage;
  final int age;
  final String petBreed;
  final List likes;
  final String description;
  final double price;

  PetsModel({
    required this.petName,
    required this.petImage,
    required this.age,
    required this.petBreed,
    required this.likes,
    required this.id,
    required this.description,
    required this.price,
  });

  factory PetsModel.fromJson(Map<String, dynamic> json) {
    return PetsModel(
      id: json['id'],
      petName: json['petName'],
      petImage: json['petImage'],
      age: json['age'],
      petBreed: json['petBreed'],
      likes: List.from(json['likes']),
      description: json['description'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petName': petName,
      'petImage': petImage,
      'age': age,
      'petBreed': petBreed,
      'likes': likes,
      'description': description,
      'price': price,
    };
  }
}

List<PetsModel> topPets = [
  PetsModel(
    petName: "George",
    petImage: "assets/images/maltese.jpg",
    age: 4,
    petBreed: "Maltese",
    likes: [],
    id: 1,
    description: "George is a friendly and playful Maltese who loves to cuddle.",
    price: 300.0,
  ),
  PetsModel(
    petName: "Patrick",
    petImage: "assets/images/shepherd.jpg",
    age: 7,
    petBreed: "German Shepherd",
    likes: [],
    id: 2,
    description: "Patrick is a loyal and protective German Shepherd.",
    price: 450.0,
  ),
  PetsModel(
    petName: "Lucifer",
    petImage: "assets/images/siberian.jpg",
    age: 13,
    petBreed: "Siberian Husky",
    likes: [],
    id: 3,
    description: "Lucifer is an energetic and adventurous Siberian Husky.",
    price: 500.0,
  ),
];

/////New Pets
List<PetsModel> newPets = [
  PetsModel(
    petName: "Chris",
    petImage: "assets/images/cava.jpg",
    age: 2,
    petBreed: "Cavalier King Charles Spaniel",
    likes: [],
    id: 4,
    description: "Chris is a gentle and affectionate Cavalier King Charles Spaniel.",
    price: 350.0,
  ),
  PetsModel(
    petName: "Anthony",
    petImage: "assets/images/rottweiler.jpg",
    age: 5,
    petBreed: "Rottweiler",
    likes: [],
    id: 5,
    description: "Anthony is a strong and confident Rottweiler.",
    price: 400.0,
  ),
  PetsModel(
    petName: "Bobby",
    petImage: "assets/images/hound.jpg",
    age: 13,
    petBreed: "Basset Hound",
    likes: [],
    id: 6,
    description: "Lucifer is a calm and friendly Basset Hound.",
    price: 250.0,
  ),
];

List<PetsModel> allPets = [...newPets, ...topPets];

