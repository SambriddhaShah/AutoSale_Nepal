import 'dart:typed_data';
import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/Drawer/drawerPage.dart';
import 'package:auto_sale_nepal/Utils/size_utils.dart';
import 'package:auto_sale_nepal/Utils/styles.dart';
import 'package:auto_sale_nepal/Utils/theme_helper.dart';
import 'package:auto_sale_nepal/Utils/toast_message.dart';
import 'package:auto_sale_nepal/profileImage/save_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  String name = "name";
  String email = "email";
  String phone = "email";
  String profileImageUrl = "";

  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? usermain = FirebaseAuth.instance.currentUser;

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

  void updateData(String name, String email, String dateofbirth,
      String phoneNumber, String profileImageUrl) async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid) // replace "userId" with the actual document ID
        .update({
      //    name = value.data()!['name'];
      // email = value.data()!['email'];
      // phone = value.data()!['Phone'];
      // profileImageUrl = value.data()!['imageLink'];
      "name": nameController.text,
      "email": emailController.text,
      // "Date of Birth": dateController.text,
      "Phone": phoneNumberController.text,
      'imageLink': _image == null ? profileImageUrl : profileImageUrl,
    });
  }

  Future<String> saveProfileImage() async {
    String resp = await StoreData().saveData(file: _image!);
    return resp;
  }

// getting user data from the firebase and showing in the application
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    phoneNumberController.text = phone;
    emailController.text = email;
    nameController.text = name;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: CustomColors.secondaryColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: CustomColors.appColor,
        elevation: 0,
        centerTitle: true,
        title: Container(
          height: 40,
          // padding: const EdgeInsets.only(right: 50),
          child: Center(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Image.asset(
                "assets/icons/auto_sale_nepal_name.png",
                height: getVerticalSize(40),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
      // drawer: DrawerWidget(),
      // body: Container(
      //   //decoration: BoxDecoration(color: CustomColors.appColor),
      //   child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      //     Container(
      //       color: CustomColors.appColor,
      //       height: getVerticalSize(40),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         children: <Widget>[
      //           // Container(
      //           //   height: getVerticalSize(20),
      //           //   decoration: BoxDecoration(
      //           //     color: CustomColors.secondaryColor,
      //           //     border: null,
      //           //     boxShadow: null,
      //           //     borderRadius: const BorderRadius.only(
      //           //       topLeft: Radius.circular(50.0),
      //           //       topRight: Radius.circular(50.0),
      //           //     ),
      //           //   ),
      //           // ),
      //         ],
      //       ),
      //     ),
      //     Icon(Icons.person_2_outlined)
      //   ]),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: getVerticalSize(10),
              ),
              Text("PROFILE", style: Styles.textBlack20B),
              SizedBox(
                height: getVerticalSize(30),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: getSize(80),
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
                                radius: getSize(80),
                                backgroundImage: MemoryImage(_image!),
                              )
                        : _image == null
                            ? CircleAvatar(
                                radius: getSize(80),
                                backgroundImage: const AssetImage(
                                    'assets/images/defaultProfile.png'),
                              )
                            : CircleAvatar(
                                radius: getSize(80),
                                backgroundImage: MemoryImage(_image!),
                              ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: CustomColors.primaryColour,
                        ),
                        // onPressed: selectImage
                        onPressed: selectImage),
                  ),
                ],
              ),
              SizedBox(
                height: getVerticalSize(20),
              ),
              Text(
                name,
                style: Styles.textBlack20B,
              ),
              SizedBox(
                height: getVerticalSize(30),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: ThemeHelper().textInputDecoration(
                        "Username", "Enter your Username "),
                    keyboardType: TextInputType.name,
                    // controller: TextEditingController(text: text),
                  ),
                ],
              ),
              SizedBox(
                height: getVerticalSize(25),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: ThemeHelper()
                        .textInputDecoration("Email", "Enter your Email "),
                    keyboardType: TextInputType.name,

                    style: Styles.textBlack16,
                    // controller: TextEditingController(text: text),
                  ),
                ],
              ),
              SizedBox(
                height: getVerticalSize(25),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: phoneNumberController,
                    decoration: ThemeHelper().textInputDecoration(
                        "Phone Number", "Enter your Phone "),
                    keyboardType: TextInputType.name,
                    style: Styles.textBlack16,
                    // controller: TextEditingController(text: text),
                  ),
                ],
              ),
              SizedBox(
                height: getVerticalSize(30),
              ),
              ElevatedButton(
                onPressed: () async {
                  Reference ref = _storage.ref().child(usermain!.uid);

                  try {
                    ListResult result = await ref.listAll();

                    // Check if the reference exists in the list
                    if (_image != null) {
                      if (result.items.isNotEmpty) {
                        // Reference exists
                        ref.delete().then((value) => {
                              saveProfileImage().then(
                                (value) {
                                  print('the new image url is $value');
                                  updateData(
                                      nameController.text,
                                      emailController.text,
                                      dateController.text,
                                      phoneNumberController.text,
                                      value);
                                },
                              ),

                              // Update appointment logic here
                              ToastMessage.showMessage('Details Updated'),
                              getUserData(),
                              // Navigator.pop(context);
                            });
                      } else {
                        // Reference does not exist

                        saveProfileImage().then(
                          (value) {
                            print('the new image url is $value');
                            updateData(
                                nameController.text,
                                emailController.text,
                                dateController.text,
                                phoneNumberController.text,
                                value);
                          },
                        );

                        // Update appointment logic here
                        ToastMessage.showMessage('Details Updated');
                        getUserData();
                        // Navigator.pop(context);
                      }
                    } else {
                      updateData(
                          nameController.text,
                          emailController.text,
                          dateController.text,
                          phoneNumberController.text,
                          profileImageUrl);
                    }
                  } catch (e) {
                    // Handle the error
                    ToastMessage.showMessage('Error Occured $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColour,
                    padding: EdgeInsets.symmetric(
                        vertical: getVerticalSize(15),
                        horizontal: getHorizontalSize(120)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(getSize(15)))),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text('Update', style: Styles.textWhite20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
