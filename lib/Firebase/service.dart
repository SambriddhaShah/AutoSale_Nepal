import 'package:auto_sale_nepal/Firebase/ListingsModel.dart';
import 'package:auto_sale_nepal/Firebase/approvedListingsModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addListing(Listing listing) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        listing.userId = user.uid; // Assign the user ID to the listing
        DocumentReference documentReference =
            _firestore.collection('listings').doc();
        await documentReference.set(listing.toMap());
      } else {
        throw Exception("User is not logged in!");
      }
    } catch (e) {
      print("Error adding listing: $e");
      throw e;
    }
  }

  static Stream<List<Listing>> getListings() {
    return _firestore
        .collection('listings')
        .where('userId', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Listing(
            id: doc.id,
            userId: data['userId'],
            name: data['name'],
            brand: data['brand'],
            makeYear: data['makeYear'],
            mileage: data['mileage'],
            numberOfOwners: data['numberOfOwners'],
            price: data['price'],
            description: data['description'],
            defects: List<String>.from(data['defects']),
            imageLinks: List<String>.from(data['imageLinks']),
            purchaserequests: List<String>.from(data['purchaserequests']),
            datetime: (data['datetime'] as Timestamp).toDate(),
            originalPrice: data['originalPrice'],
            location: data['location']);
      }).toList();
    });
  }

// retrive a single listing using the id
  static Stream<Listing?> getListingById(String docId) {
    return _firestore.collection('listings').doc(docId).snapshots().map((doc) {
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Listing(
            id: doc.id,
            userId: data['userId'],
            name: data['name'],
            brand: data['brand'],
            makeYear: data['makeYear'],
            mileage: data['mileage'],
            numberOfOwners: data['numberOfOwners'],
            price: data['price'],
            description: data['description'],
            defects: List<String>.from(data['defects']),
            imageLinks: List<String>.from(data['imageLinks']),
            purchaserequests: List<String>.from(
              data['purchaserequests'],
            ),
            datetime: (data['datetime'] as Timestamp).toDate(),
            originalPrice: data['originalPrice'],
            location: data['location']);
      } else {
        return null; // Return null if the document doesn't exist
      }
    });
  }

  // Listings sorted accrding to time
  static Stream<List<Listing>> getListingssortedtime() {
    return _firestore
        .collection('listings')
        .orderBy('datetime',
            descending: false) // Order by 'createdAt' field in ascending order
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Listing(
            id: doc.id,
            userId: data['userId'],
            name: data['name'],
            brand: data['brand'],
            makeYear: data['makeYear'],
            mileage: data['mileage'],
            numberOfOwners: data['numberOfOwners'],
            price: data['price'],
            description: data['description'],
            defects: List<String>.from(data['defects']),
            imageLinks: List<String>.from(data['imageLinks']),
            purchaserequests: List<String>.from(
              data['purchaserequests'],
            ),
            datetime: (data['datetime'] as Timestamp).toDate(),
            originalPrice: data['originalPrice'],
            location: data['location']);
      }).toList();
    });
  }

  // ListingBySearch Query
  static Stream<List<Listing>> getListingsbySearch(String searchString) {
    return _firestore
        .collection('listings')
        .where('name', isGreaterThanOrEqualTo: searchString)
        .where('name',
            isLessThan: searchString +
                'z') // Ensure that names starting with the search string are retrieved
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Listing(
            id: doc.id,
            userId: data['userId'],
            name: data['name'],
            brand: data['brand'],
            makeYear: data['makeYear'],
            mileage: data['mileage'],
            numberOfOwners: data['numberOfOwners'],
            price: data['price'],
            description: data['description'],
            defects: List<String>.from(data['defects']),
            imageLinks: List<String>.from(data['imageLinks']),
            purchaserequests: List<String>.from(data['purchaserequests']),
            datetime: (data['datetime'] as Timestamp).toDate(),
            originalPrice: data['originalPrice'],
            location: data['location']);
      }).toList();
    });
  }

// Listing data for the most popular listings

  static Future<List<Listing>> getListingsWithMorePurchaseRequests() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('listings')
        .where('userId', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    List<Listing> listings = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Listing(
          id: doc.id,
          userId: data['userId'],
          name: data['name'],
          brand: data['brand'],
          makeYear: data['makeYear'],
          mileage: data['mileage'],
          numberOfOwners: data['numberOfOwners'],
          price: data['price'],
          description: data['description'],
          defects: List<String>.from(data['defects']),
          imageLinks: List<String>.from(data['imageLinks']),
          purchaserequests: List<String>.from(data['purchaserequests']),
          datetime: (data['datetime'] as Timestamp).toDate(),
          originalPrice: data['originalPrice'],
          location: data['location']);
    }).toList();

    // Sort the listings by the length of purchaserequests array in descending order
    listings.sort((a, b) =>
        b.purchaserequests.length.compareTo(a.purchaserequests.length));

    // Take only the first six listings
    return listings.take(6).toList();
  }

//  Listings for the current user only
  static Stream<List<Listing>> getListingsForUser() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('listings')
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return Listing(
              id: doc.id,
              userId: data['userId'],
              name: data['name'],
              brand: data['brand'],
              makeYear: data['makeYear'],
              mileage: data['mileage'],
              numberOfOwners: data['numberOfOwners'],
              price: data['price'],
              description: data['description'],
              defects: List<String>.from(data['defects']),
              imageLinks: List<String>.from(data['imageLinks']),
              purchaserequests: List<String>.from(data['purchaserequests']),
              datetime: (data['datetime'] as Timestamp).toDate(),
              originalPrice: data['originalPrice'],
              location: data['location']);
        }).toList();
      });
    } else {
      throw Exception("User is not logged in!");
    }
  }

//Listings the user has sent purchase request to
  static Stream<List<Listing>> getListingsForinterested() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('listings')
          .where('purchaserequests',
              arrayContains: user.uid) // Filter based on purchaserequests
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return Listing(
              id: doc.id,
              userId: data['userId'],
              name: data['name'],
              brand: data['brand'],
              makeYear: data['makeYear'],
              mileage: data['mileage'],
              numberOfOwners: data['numberOfOwners'],
              price: data['price'],
              description: data['description'],
              defects: List<String>.from(data['defects']),
              imageLinks: List<String>.from(data['imageLinks']),
              purchaserequests: List<String>.from(data['purchaserequests']),
              datetime: (data['datetime'] as Timestamp).toDate(),
              originalPrice: data['originalPrice'],
              location: data['location']);
        }).toList();
      });
    } else {
      throw Exception("User is not logged in!");
    }
  }

// update the listing
  static Future<void> updateListing(Listing listing) async {
    try {
      await _firestore
          .collection('listings')
          .doc(listing.id)
          .update(listing.toMap());
    } catch (e) {
      print("Error updating listing: $e");
      throw e;
    }
  }

// delete the listing
  static Future<void> deleteListing(String listingId, String userid) async {
    try {
      DocumentSnapshot deleteedlisting =
          await _firestore.collection('listings').doc(listingId).get();
      Map<String, dynamic> data =
          deleteedlisting.data() as Map<String, dynamic>;
      await _firestore
          .collection('history')
          .doc(userid)
          .collection('deleted')
          .doc(listingId)
          .set(data);
      await _firestore.collection('listings').doc(listingId).delete();
    } catch (e) {
      print("Error deleting listing: $e");
      throw e;
    }
  }

  // Purchase Request Section

  // Send Purchase Request
  static Future<void> sendPurchaseRequestToListing(
      String listingId, String userId) async {
    try {
      await _firestore.collection('listings').doc(listingId).update({
        'purchaserequests': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      print("Error sending purchase request: $e");
      throw e;
    }
  }

  // get all user's data from the list of uid
  static Future<Map<String, dynamic>> getUserDataForPurchaseRequests(
      List<String> userIds) async {
    print('the id list is $userIds');
    Map<String, dynamic> userDataMap = {};

    try {
      for (String userId in userIds) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection("Users")
            .doc(userId)
            .get();
        // await _firestore.collection('users').doc(userId).get();
        if (userSnapshot.exists) {
          print('the usersnapshot is $userSnapshot');
          userDataMap[userId] = userSnapshot.data();
        }
      }
      return userDataMap;
    } catch (e) {
      print("Error fetching user data: $e");
      throw e;
    }

    return userDataMap;
  }

  // Purchase request approval
  static Future<void> approvePurchaseRequest(
      String listingId, ApprovedListing listingnew) async {
    try {
      // Retrieve original listing document
      DocumentSnapshot listingSnapshot =
          await _firestore.collection('listings').doc(listingId).get();
      if (listingSnapshot.exists) {
        // Create approved listing document in "approvedListings" collection
        await _firestore
            .collection('approvedListings')
            .doc(listingId)
            .set(listingnew.toMap());

        // Update purchaserequests field in approved listing
        // await _firestore.collection('approvedListings').doc(listingId).update({
        //   'purchaserequests': approvedRequestUid,
        // });

        // Delete original listing from "listings" collection
        await _firestore.collection('listings').doc(listingId).delete();
      } else {
        throw Exception("Listing not found!");
      }
    } catch (e) {
      print("Error approving purchase request: $e");
      throw e;
    }
  }

  //  Appproved Listings for the current user only
  static Stream<List<ApprovedListing>> getApprovedListingsForBuyer() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('approvedListings')
          .where('purchaserequests', isEqualTo: user.uid)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return ApprovedListing(
              id: doc.id,
              userId: data['userId'],
              name: data['name'],
              brand: data['brand'],
              makeYear: data['makeYear'],
              mileage: data['mileage'],
              numberOfOwners: data['numberOfOwners'],
              price: data['price'],
              description: data['description'],
              defects: List<String>.from(data['defects']),
              imageLinks: List<String>.from(data['imageLinks']),
              purchaserequests: data['purchaserequests'],
              datetime: (data['datetime'] as Timestamp).toDate(),
              originalPrice: data['originalPrice'],
              isCOD: data['isCOD'],
              isPaid: data['isPaid'],
              isCompleted: data['isCompleted'],
              location: data['location']);
        }).toList();
      });
    } else {
      throw Exception("User is not logged in!");
    }
  }

  //  Appproved Listings for the current user only
  static Stream<List<ApprovedListing>> getApprovedListingsForSeller() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('approvedListings')
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return ApprovedListing(
              id: doc.id,
              userId: data['userId'],
              name: data['name'],
              brand: data['brand'],
              makeYear: data['makeYear'],
              mileage: data['mileage'],
              numberOfOwners: data['numberOfOwners'],
              price: data['price'],
              description: data['description'],
              defects: List<String>.from(data['defects']),
              imageLinks: List<String>.from(data['imageLinks']),
              purchaserequests: data['purchaserequests'],
              datetime: (data['datetime'] as Timestamp).toDate(),
              originalPrice: data['originalPrice'],
              isCOD: data['isCOD'],
              isPaid: data['isPaid'],
              isCompleted: data['isCompleted'],
              location: data['location']);
        }).toList();
      });
    } else {
      throw Exception("User is not logged in!");
    }
  }

  // retrive a single Approved listing using the id
  static Stream<ApprovedListing?> getApprovedListingById(String listingId) {
    return _firestore
        .collection('approvedListings')
        .doc(listingId) // Use the document ID to query a specific listing
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        print('the data is ${snapshot.data()}');
        Map<String, dynamic> data = snapshot.data()!;
        return ApprovedListing(
            id: snapshot.id,
            userId: data['userId'],
            name: data['name'],
            brand: data['brand'],
            makeYear: data['makeYear'],
            mileage: data['mileage'],
            numberOfOwners: data['numberOfOwners'],
            price: data['price'],
            description: data['description'],
            defects: List<String>.from(data['defects']),
            imageLinks: List<String>.from(data['imageLinks']),
            purchaserequests: data['purchaserequests'],
            datetime: (data['datetime'] as Timestamp).toDate(),
            originalPrice: data['originalPrice'],
            isCOD: data['isCOD'],
            isPaid: data['isPaid'],
            isCompleted: data['isCompleted'],
            location: data['location']);
      } else {
        // If the document doesn't exist, return null
        return null;
      }
    });
  }

  // update certain parameter in approved listings
  // Function to update a specific parameter in an approved listing
  static Future<void> updateApprovedListingParameter(
      String listingId, String parameter, dynamic value) async {
    try {
      await _firestore.collection('approvedListings').doc(listingId).update({
        parameter: value,
      });
    } catch (e) {
      print("Error updating parameter in approved listing: $e");
      throw e;
    }
  }

  // Function to move approved listing to history and delete from approvedListings
  static Future<void> moveApprovedListingToHistoryAndDelete(
      String approvedListingId) async {
    try {
      // Get the approved listing
      DocumentSnapshot approvedListingSnapshot = await _firestore
          .collection('approvedListings')
          .doc(approvedListingId)
          .get();
      if (approvedListingSnapshot.exists) {
        // Get data of the approved listing
        Map<String, dynamic> data =
            approvedListingSnapshot.data() as Map<String, dynamic>;

        // Store approved listing in "history/selled" collection with seller's user ID as document ID
        await _firestore
            .collection('history')
            .doc(data['userId'])
            .collection('selled')
            .doc(approvedListingId)
            .set(data);

        // Store approved listing in "history/bought" collection with purchaser's user ID (from purchaserequests) as document ID
        await _firestore
            .collection('history')
            .doc(data['purchaserequests'])
            .collection('bought')
            .doc(approvedListingId)
            .set(data);

        // Delete the approved listing from "approvedListings" collection
        await _firestore
            .collection('approvedListings')
            .doc(approvedListingId)
            .delete();
      } else {
        throw Exception("Approved listing not found!");
      }
    } catch (e) {
      print("Error moving approved listing to history and deleting: $e");
      throw e;
    }
  }

  // Function to get selled listings for the current user
  static Stream<List<ApprovedListing>> getSelledListingsForUser() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('history')
          .doc(user.uid)
          .collection('selled')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return ApprovedListing(
            id: doc.id,
            userId: data['userId'],
            name: data['name'],
            brand: data['brand'],
            makeYear: data['makeYear'],
            mileage: data['mileage'],
            numberOfOwners: data['numberOfOwners'],
            price: data['price'],
            description: data['description'],
            defects: List<String>.from(data['defects']),
            imageLinks: List<String>.from(data['imageLinks']),
            purchaserequests: data['purchaserequests'],
            datetime: (data['datetime'] as Timestamp).toDate(),
            originalPrice: data['originalPrice'],
            isCOD: data['isCOD'],
            isPaid: data['isPaid'],
            isCompleted: data['isCompleted'],
            location: data['location'],
          );
        }).toList();
      });
    } else {
      throw Exception("User is not logged in!");
    }
  }

  // Function to get selled listings for the current user
  static Stream<List<ApprovedListing>> getdeletedListingsForUser() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('history')
          .doc(user.uid)
          .collection('deleted')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return ApprovedListing(
            id: doc.id,
            userId: data['userId'],
            name: data['name'],
            brand: data['brand'],
            makeYear: data['makeYear'],
            mileage: data['mileage'],
            numberOfOwners: data['numberOfOwners'],
            price: data['price'],
            description: data['description'],
            defects: List<String>.from(data['defects']),
            imageLinks: List<String>.from(data['imageLinks']),
            purchaserequests: '',
            datetime: (data['datetime'] as Timestamp).toDate(),
            originalPrice: data['originalPrice'],
            isCOD: '',
            isPaid: '',
            isCompleted: '',
            location: data['location'],
          );
        }).toList();
      });
    } else {
      throw Exception("User is not logged in!");
    }
  }

  // Function to get bought listings for the current user
  static Stream<List<ApprovedListing>> getBoughtListingsForUser() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('history')
          .doc(user.uid)
          .collection('bought')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return ApprovedListing(
            id: doc.id,
            userId: data['userId'],
            name: data['name'],
            brand: data['brand'],
            makeYear: data['makeYear'],
            mileage: data['mileage'],
            numberOfOwners: data['numberOfOwners'],
            price: data['price'],
            description: data['description'],
            defects: List<String>.from(data['defects']),
            imageLinks: List<String>.from(data['imageLinks']),
            purchaserequests: data['purchaserequests'],
            datetime: (data['datetime'] as Timestamp).toDate(),
            originalPrice: data['originalPrice'],
            isCOD: data['isCOD'],
            isPaid: data['isPaid'],
            isCompleted: data['isCompleted'],
            location: data['location'],
          );
        }).toList();
      });
    } else {
      throw Exception("User is not logged in!");
    }
  }

  // get all user's data from the list of uid except the current user
  static Future<Map<String, dynamic>> getAllUserDataExceptCurrentUser(
      String currentUserId) async {
    Map<String, dynamic> userDataMap = {};

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("Users").get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        if (docSnapshot.id != currentUserId) {
          userDataMap[docSnapshot.id] = docSnapshot.data();
        }
      }

      return userDataMap;
    } catch (e) {
      print("Error fetching user data: $e");
      throw e;
    }
  }

  //  Listings for the current user only for admin
  static Stream<List<Listing>> getListingsForUserAdmin(String id) {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('listings')
          .where('userId', isEqualTo: id)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return Listing(
              id: doc.id,
              userId: data['userId'],
              name: data['name'],
              brand: data['brand'],
              makeYear: data['makeYear'],
              mileage: data['mileage'],
              numberOfOwners: data['numberOfOwners'],
              price: data['price'],
              description: data['description'],
              defects: List<String>.from(data['defects']),
              imageLinks: List<String>.from(data['imageLinks']),
              purchaserequests: List<String>.from(data['purchaserequests']),
              datetime: (data['datetime'] as Timestamp).toDate(),
              originalPrice: data['originalPrice'],
              location: data['location']);
        }).toList();
      });
    } else {
      throw Exception("User is not logged in!");
    }
  }

  //  Appproved Listings for the current user only
  static Stream<List<ApprovedListing>> getApprovedListingsForBuyerAdmin(
      String id) {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('approvedListings')
          .where('purchaserequests', isEqualTo: id)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return ApprovedListing(
              id: doc.id,
              userId: data['userId'],
              name: data['name'],
              brand: data['brand'],
              makeYear: data['makeYear'],
              mileage: data['mileage'],
              numberOfOwners: data['numberOfOwners'],
              price: data['price'],
              description: data['description'],
              defects: List<String>.from(data['defects']),
              imageLinks: List<String>.from(data['imageLinks']),
              purchaserequests: data['purchaserequests'],
              datetime: (data['datetime'] as Timestamp).toDate(),
              originalPrice: data['originalPrice'],
              isCOD: data['isCOD'],
              isPaid: data['isPaid'],
              isCompleted: data['isCompleted'],
              location: data['location']);
        }).toList();
      });
    } else {
      throw Exception("User is not logged in!");
    }
  }

  // Function to get selled listings for the current user
  static Stream<List<ApprovedListing>> getSelledListingsForUserAdmin(
      String id) {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('history')
          .doc(id)
          .collection('selled')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return ApprovedListing(
            id: doc.id,
            userId: data['userId'],
            name: data['name'],
            brand: data['brand'],
            makeYear: data['makeYear'],
            mileage: data['mileage'],
            numberOfOwners: data['numberOfOwners'],
            price: data['price'],
            description: data['description'],
            defects: List<String>.from(data['defects']),
            imageLinks: List<String>.from(data['imageLinks']),
            purchaserequests: data['purchaserequests'],
            datetime: (data['datetime'] as Timestamp).toDate(),
            originalPrice: data['originalPrice'],
            isCOD: data['isCOD'],
            isPaid: data['isPaid'],
            isCompleted: data['isCompleted'],
            location: data['location'],
          );
        }).toList();
      });
    } else {
      throw Exception("User is not logged in!");
    }
  }

  // Function to get bought listings for the current user
  static Stream<List<ApprovedListing>> getBoughtListingsForUserAdmin(
      String id) {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('history')
          .doc(id)
          .collection('bought')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return ApprovedListing(
            id: doc.id,
            userId: data['userId'],
            name: data['name'],
            brand: data['brand'],
            makeYear: data['makeYear'],
            mileage: data['mileage'],
            numberOfOwners: data['numberOfOwners'],
            price: data['price'],
            description: data['description'],
            defects: List<String>.from(data['defects']),
            imageLinks: List<String>.from(data['imageLinks']),
            purchaserequests: data['purchaserequests'],
            datetime: (data['datetime'] as Timestamp).toDate(),
            originalPrice: data['originalPrice'],
            isCOD: data['isCOD'],
            isPaid: data['isPaid'],
            isCompleted: data['isCompleted'],
            location: data['location'],
          );
        }).toList();
      });
    } else {
      throw Exception("User is not logged in!");
    }
  }
}
