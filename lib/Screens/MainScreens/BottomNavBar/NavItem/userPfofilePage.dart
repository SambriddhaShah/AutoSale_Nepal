import 'dart:typed_data';

import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/Drawer/drawerPage.dart';
import 'package:auto_sale_nepal/Screens/Screen/Admin/AdminDrawer.dart';
import 'package:auto_sale_nepal/Screens/Screen/Profile/profileUpdate.dart';
import 'package:auto_sale_nepal/Utils/size_utils.dart';
import 'package:auto_sale_nepal/Utils/styles.dart';
import 'package:auto_sale_nepal/profileImage/save_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "name";
  String email = "email";
  String phone = "email";
  String profileImageUrl = "";
  String isAdmin = 'false';

  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  XFile? file;
  bool isImagePickerActive = false;

  @override
  void initState() {
    getUserData();

    super.initState();
  }

  Uint8List? _image;
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    file = await _imagePicker.pickImage(source: source);
    if (file != null) {
      return await file!.readAsBytes();
    }
    print("No image Selected");
  }

  void selectImage() async {
    if (!isImagePickerActive) {
      isImagePickerActive = true;

      Uint8List? img = await pickImage(ImageSource.gallery);

      setState(() {
        _image = img;
      });

      // After image picking is complete, set isImagePickerActive to false
      isImagePickerActive = false;
    }
  }

  Future<String> saveProfileImage() async {
    String resp = await StoreData().saveData(file: _image!);
    return resp;
  }

// creating user and storing it in a collection 'users'
  void getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    var value = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .get();
    if (value.exists) {
      setState(() {
        name = value.data()!['name'];
        email = value.data()!['email'];
        phone = value.data()!['Phone'];
        profileImageUrl = value.data()!['imageLink'];
        isAdmin = value.data()!['isAdmin'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    phoneNumberController.text = phone;
    emailController.text = email;
    nameController.text = name;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            size: getSize(30),
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ), // iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: CustomColors.appColor,
        elevation: 0,
        centerTitle: true,
        title: Container(
          height: 40,
          // padding: const EdgeInsets.only(right: 50),
          child: Center(
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Text(
                  'PROFILE',
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ),
      ),
      drawer: isAdmin == 'true' ? AdminDrawerWidget() : DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2 - 40,
              decoration: BoxDecoration(
                  color: CustomColors.appColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                builder: (context) => ProfileUpdatePage(),
                              ))
                              .then((value) => {getUserData()});
                          // Reference ref = _storage.ref().child(usermain!.uid);

                          // try {
                          //   ListResult result = await ref.listAll();

                          //   // Check if the reference exists in the list
                          //   if (result.items.isNotEmpty) {
                          //     // Reference exists
                          //     ref.delete().then((value) => {
                          //           // saveProfileImage().then(
                          //           //   (value) {
                          //           //     print('the new image url is $value');
                          //           //     updateData(
                          //           //         nameController.text,
                          //           //         emailController.text,
                          //           //         dateController.text,
                          //           //         phoneNumberController.text,
                          //           //         value);
                          //           //   },
                          //           // ),

                          //           // Update appointment logic here
                          //           ScaffoldMessenger.of(context).showSnackBar(
                          //             const SnackBar(
                          //               content: Text('Details Updated'),
                          //             ),
                          //           ),
                          //           // getUserData(),
                          //           // Navigator.pop(context);
                          //         });
                          //   } else {
                          //     // Reference does not exist

                          //     // saveProfileImage().then(
                          //     //   (value) {
                          //     //     print('the new image url is $value');
                          //     //     updateData(
                          //     //         nameController.text,
                          //     //         emailController.text,
                          //     //         dateController.text,
                          //     //         phoneNumberController.text,
                          //     //         value);
                          //     //   },
                          //     // );

                          //     // Update appointment logic here
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(
                          //         content: Text('Details Updated'),
                          //       ),
                          //     );
                          //     // getUserData();
                          //     // Navigator.pop(context);
                          //   }
                          // } catch (e) {
                          //   // Handle the error
                          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //     content: Text('Error Occured $e'),
                          //   ));
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                                vertical: getVerticalSize(5),
                                horizontal: getHorizontalSize(10)),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(getSize(15)))),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: getSize(20),
                              ),
                              Text('Edit Profile', style: Styles.textWhite5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getVerticalSize(10),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: getSize(100),
                        // backgroundImage: AssetImage('assets/images/p4.png'),
                        backgroundImage: profileImageUrl.isNotEmpty
                            ? _image == null
                                ? NetworkImage(profileImageUrl)
                                : null
                            : null,
                        child: profileImageUrl.isNotEmpty
                            ? _image == null
                                ? null
                                : CircleAvatar(
                                    radius: getSize(100),
                                    backgroundImage: MemoryImage(_image!),
                                  )
                            : _image == null
                                ? CircleAvatar(
                                    radius: getSize(100),
                                    backgroundImage: const AssetImage(
                                        'assets/images/defaultProfile.png'),
                                  )
                                : CircleAvatar(
                                    radius: getSize(100),
                                    backgroundImage: MemoryImage(_image!),
                                  ),
                      ),
                      // Positioned(
                      //   bottom: -10,
                      //   right: 0,
                      //   child: IconButton(
                      //       icon: const Icon(
                      //         Icons.camera_alt,
                      //         color: CustomColors.secondaryColor,
                      //       ),
                      //       // onPressed: selectImage
                      //       onPressed: selectImage),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: getVerticalSize(40),
                  ),
                  Text(
                    name,
                    style: Styles.textWhite26,
                  ),
                  SizedBox(
                    height: getVerticalSize(30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.call,
                        color: CustomColors.secondaryColor,
                        size: getSize(20),
                      ),
                      Text(
                        " : $phone",
                        style: Styles.textWhite14,
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: getVerticalSize(30),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email,
                        color: CustomColors.secondaryColor,
                        size: getSize(20),
                      ),
                      Text(
                        " : $email",
                        style: Styles.textWhite14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: getVerticalSize(30),
            ),
            Padding(
              padding: getPadding(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: getVerticalSize(90),
                        width: getHorizontalSize(140),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: CustomColors.appColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Listed',
                              style: Styles.textWhite20,
                            ),
                            SizedBox(
                              height: getVerticalSize(30),
                            ),
                            Text(
                              '10',
                              style: Styles.textWhite20,
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: getVerticalSize(90),
                        width: getHorizontalSize(140),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: CustomColors.appColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Bought',
                              style: Styles.textWhite20,
                            ),
                            SizedBox(
                              height: getVerticalSize(30),
                            ),
                            Text(
                              '10',
                              style: Styles.textWhite20,
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
