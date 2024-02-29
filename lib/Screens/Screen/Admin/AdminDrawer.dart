import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/SelectorPage.dart';
import 'package:auto_sale_nepal/Screens/Screen/Admin/manageUsers.dart';
import 'package:auto_sale_nepal/Screens/Screen/Profile/profileUpdate.dart';
import 'package:auto_sale_nepal/Screens/Screen/userListings/PurchaseRequest.dart';
import 'package:auto_sale_nepal/Screens/Screen/userListings/UserListings.dart';
import 'package:auto_sale_nepal/Utils/flutter_local_storage.dart';
import 'package:auto_sale_nepal/Utils/size_utils.dart';
import 'package:auto_sale_nepal/Utils/styles.dart';
import 'package:auto_sale_nepal/Utils/toast_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDrawerWidget extends StatefulWidget {
  const AdminDrawerWidget({super.key});

  @override
  State<AdminDrawerWidget> createState() => _AdminDrawerWidgetState();
}

class _AdminDrawerWidgetState extends State<AdminDrawerWidget> {
  String name = "name";
  String email = "email";
  String profileImageUrl = "";

  @override
  void initState() {
    getUserData();

    super.initState();
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
        profileImageUrl = value.data()!['imageLink'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: CustomColors.appColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                    radius: getSize(50),
                    backgroundImage: profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl)
                        : null,
                    child: profileImageUrl.isEmpty
                        ? CircleAvatar(
                            radius: getSize(60),
                            backgroundImage: const AssetImage(
                                'assets/images/defaultProfile.png'),
                          )
                        : null

                    // const AssetImage('assets/annapurna_trek.jpg'),
                    ),
                SizedBox(height: getVerticalSize(15)),
                Text(name, // Replace with the user's name
                    style: Styles.textWhite20),
              ],
            ),
          ),
          // ListTile(
          //   leading: const Icon(Icons.home),
          //   title: Text(
          //     'HOME',
          //     style: Styles.textBlack18,
          //   ),
          //   onTap: () {
          //     // Navigate to the dashboard page (same page)
          //     Navigator.pop(context);
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.manage_accounts),
            title: Text(
              'EDIT PROFILE',
              style: Styles.textBlack18,
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfileUpdatePage()));
            },
          ),

          ListTile(
            leading: const Icon(Icons.supervised_user_circle),
            title: Text(
              'MANAGE USERS',
              style: Styles.textBlack18,
            ),
            onTap: () {
              // Navigate to the dashboard page (same page)
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ManageUserPage(),
              ));
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(
              'LOGOUT',
              style: Styles.textBlack18,
            ),
            onTap: () {
              FlutterSecureData.deleteUserUid().then((value) => {
                    FirebaseAuth.instance.signOut().then((value) => {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => SelectorPage(),
                          )),
                          ToastMessage.showMessage("LogOut Sucessfully"),
                        })
                  });
              // FirebaseAuth.instance.signOut().then((value) {
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => LoginPage()));
              // });

              // // Navigate to the login page and remove all previous routes
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(builder: (context) => login()),
              //   (Route<dynamic> route) => false,
              // );
              // Update appointment logic here
            },
          )
        ],
      ),
    );
  }
}
