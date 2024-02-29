import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
User? user = FirebaseAuth.instance.currentUser;

class StoreDataListing {
  Future<String> uploadeImageToStorage(String childName, Uint8List file) async {
    // childName is the name of the file
    // reference is datatype of dart to pass object among functions
    Reference ref = _storage.ref().child(childName);

    // uploadTask referes to the process of uploading the file or images to the remote server
    UploadTask uploadTask = ref.putData(file);

    // tasksnapshot is  an object that represent the current state of a synchronous task such as upload and download
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print('the url $downloadUrl');
    return downloadUrl;
  }

  Future<String> saveData({required Uint8List file}) async {
    var imageUrl;
    try {
      imageUrl = await uploadeImageToStorage(
          DateTime.now().millisecondsSinceEpoch.toString(), file);
      // await
    } catch (err) {
      print(err.toString());
    }
    return imageUrl;
  }
}
