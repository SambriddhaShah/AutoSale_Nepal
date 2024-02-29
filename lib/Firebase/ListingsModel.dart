// class Listing {
//   String id;
//   String userId; // Added field to store the user ID
//   String name;
//   String brand;
//   int makeYear;
//   int mileage;
//   int numberOfOwners;
//   double price;
//   String description;
//   List<String> defects;
//   List<String> imageLinks;

//   Listing({
//     required this.id,
//     required this.userId,
//     required this.name,
//     required this.brand,
//     required this.makeYear,
//     required this.mileage,
//     required this.numberOfOwners,
//     required this.price,
//     required this.description,
//     required this.defects,
//     required this.imageLinks,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'userId': userId,
//       'name': name,
//       'brand': brand,
//       'makeYear': makeYear,
//       'mileage': mileage,
//       'numberOfOwners': numberOfOwners,
//       'price': price,
//       'description': description,
//       'defects': defects,
//       'imageLinks': imageLinks,
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  String? id;
  String userId; // Added field to store the user ID
  String name;
  String brand;
  String makeYear;
  String mileage;
  String numberOfOwners;
  String price;
  String description;
  List<String> defects;
  List<String> imageLinks;
  List<String> purchaserequests;
  DateTime datetime;
  String originalPrice;
  String location;

  Listing(
      {required this.id,
      required this.userId,
      required this.name,
      required this.brand,
      required this.makeYear,
      required this.mileage,
      required this.numberOfOwners,
      required this.price,
      required this.description,
      required this.defects,
      required this.imageLinks,
      required this.purchaserequests,
      required this.datetime,
      required this.originalPrice,
      required this.location});

  // Constructor to create Listing object from Firestore snapshot
  Listing.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        userId = snapshot['userId'],
        name = snapshot['name'],
        brand = snapshot['brand'],
        makeYear = snapshot['makeYear'],
        mileage = snapshot['mileage'],
        numberOfOwners = snapshot['numberOfOwners'],
        price = snapshot['price'].toDouble(),
        description = snapshot['description'],
        defects = List<String>.from(snapshot['defects']),
        imageLinks = List<String>.from(snapshot['imageLinks']),
        purchaserequests = List<String>.from(
          snapshot['purchaserequests'],
        ),
        datetime = snapshot['datetime'],
        originalPrice = snapshot['originalPrice'],
        location = snapshot['location'];

  // Method to convert Listing object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'brand': brand,
      'makeYear': makeYear,
      'mileage': mileage,
      'numberOfOwners': numberOfOwners,
      'price': price,
      'description': description,
      'defects': defects,
      'imageLinks': imageLinks,
      'purchaserequests': purchaserequests,
      'datetime': datetime,
      'originalPrice': originalPrice,
      'location': location
    };
  }

  // Static method to create Listing object from a map
  static Listing fromMap(Map<String, dynamic> map) {
    return Listing(
        id: map['id'],
        userId: map['userId'],
        name: map['name'],
        brand: map['brand'],
        makeYear: map['makeYear'],
        mileage: map['mileage'],
        numberOfOwners: map['numberOfOwners'],
        price: map['price'],
        description: map['description'],
        defects: List<String>.from(map['defects']),
        imageLinks: List<String>.from(map['imageLinks']),
        purchaserequests: List<String>.from(map['purchaserequests']),
        datetime: map['datetime'],
        originalPrice: map['originalPrice'],
        location: map['location']);
  }
}
