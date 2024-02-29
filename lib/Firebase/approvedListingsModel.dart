import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovedListing {
  String id;
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
  String purchaserequests;
  DateTime datetime;
  String originalPrice;
  String isPaid;
  String isCOD;
  String isCompleted;
  String location;

  ApprovedListing(
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
      required this.isCOD,
      required this.isPaid,
      required this.isCompleted,
      required this.location});

  // Constructor to create ApprovedListing object from Firestore snapshot
  ApprovedListing.fromSnapshot(DocumentSnapshot snapshot)
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
        purchaserequests = snapshot['purchaserequests'],
        datetime = snapshot['datetime'],
        originalPrice = snapshot['originalPrice'],
        isCOD = snapshot['isCOD'],
        isPaid = snapshot['isPaid'],
        isCompleted = snapshot['isCompleted'],
        location = snapshot['location'];

  // Method to convert ApprovedListing object to a map
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
      'isPaid': isPaid,
      'isCOD': isCOD,
      'isCompleted': isCompleted,
      'location': location
    };
  }

  // Static method to create ApprovedListing object from a map
  static ApprovedListing fromMap(Map<String, dynamic> map) {
    return ApprovedListing(
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
        purchaserequests: map['purchaserequests'],
        datetime: map['datetime'],
        originalPrice: map['originalPrice'],
        isCOD: map['isCOD'],
        isPaid: map['isPaid'],
        isCompleted: map['isCompleted'],
        location: map['location']);
  }
}
