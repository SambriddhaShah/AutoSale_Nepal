import 'dart:async';

import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Firebase/ListingsModel.dart';
import 'package:auto_sale_nepal/Firebase/service.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/Drawer/drawerPage.dart';
import 'package:auto_sale_nepal/Utils/size_utils.dart';
import 'package:auto_sale_nepal/Utils/styles.dart';
import 'package:auto_sale_nepal/Utils/toast_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManageListingsPage extends StatefulWidget {
  const ManageListingsPage({super.key});

  @override
  State<ManageListingsPage> createState() => _ManageListingsPageState();
}

class _ManageListingsPageState extends State<ManageListingsPage> {
  List data = [1];
  StreamSubscription<List<Listing>>? _listingsSubscription;
  List<Listing> _listings = [];
  bool _isLoading = true;
  Map<String, dynamic> userData = {};

  // getting user data from the firebase and showing in the application
  void getUserData() async {
    try {
      var Data = await FirebaseService.getAllUserDataExceptCurrentUser(
          FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        userData = Data;
      });
      print("the user's data is $userData");
      // Now userData contains user data for all the specified user IDs
    } catch (e) {
      ToastMessage.showMessage("Error Occured while fetching User's Data");
      print("Failed to fetch user data: $e");
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    _listingsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      drawer: DrawerWidget(),
      body: _isLoading == true
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: CustomColors.appColor,
                  )
                ],
              ),
            )
          : Container(
              //decoration: BoxDecoration(color: CustomColors.appColor),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  color: CustomColors.appColor,
                  height: getVerticalSize(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: getVerticalSize(20),
                        decoration: const BoxDecoration(
                          color: CustomColors.secondaryColor,
                          border: null,
                          boxShadow: null,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Purchase Request For My Listings",
                        style: Styles.textBlack24B)
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                _listings.isEmpty
                    ? Expanded(
                        child: Container(
                          // height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'No Data to Show',
                                style: Styles.textBlack15B,
                              )
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          data.isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                  itemCount: userData.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> user =
                                        userData!.values.elementAt(index);
                                    String key = userData.keys.elementAt(index);
                                    return Container(
                                      width: MediaQuery.of(context).size.width -
                                          20,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7.5),
                                          border: Border.all(
                                              color: CustomColors.appColor)),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.35,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                        radius: getSize(50),
                                                        backgroundImage: user[
                                                                    'imageLink'] !=
                                                                null
                                                            ? NetworkImage(user[
                                                                'imageLink'])
                                                            : null,
                                                        child:
                                                            user['imageLink'] ==
                                                                    null
                                                                ? CircleAvatar(
                                                                    radius:
                                                                        getSize(
                                                                            60),
                                                                    backgroundImage:
                                                                        const AssetImage(
                                                                            'assets/images/defaultProfile.png'),
                                                                  )
                                                                : null

                                                        // const AssetImage('assets/annapurna_trek.jpg'),
                                                        ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Name ${user['name']}",
                                                    // "Total Km's :",
                                                    style: Styles
                                                        .textBlack15BNormal,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Name ${user['Phone']}",
                                                    // "Total Km's :",
                                                    style: Styles
                                                        .textBlack15BNormal,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ))
                              : Text(
                                  'No Data Found',
                                  style: Styles.textBlack14B,
                                )
                        ],
                      ))
              ]),
            ),
    );
  }

  void showDialogue(BuildContext context1, String name, String id) {
    BuildContext dialogContext;

    showDialog(
        context: context1,
        builder: (BuildContext context) {
          dialogContext = context; // Capture the context

          // ... other dialog code

          return StatefulBuilder(builder: (context, setState) {
            // ignore: deprecated_member_use
            return WillPopScope(
              onWillPop: () async {
                // Use the captured context here
                return false;
                // ... handle pop scope logic
              },
              child: AlertDialog(
                  backgroundColor: CustomColors.appColor,
                  title: Text(
                    'Delete Listing',
                    style: Styles.textWhite24,
                  ),
                  actions: [
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(getSize(16)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                    color: CustomColors.secondaryColor)),
                            fixedSize: Size(
                                getHorizontalSize(100), getVerticalSize(20)),
                            backgroundColor: Colors.transparent,
                          ),
                          child: Center(
                              child: Text('Discard',
                                  style: Styles.buttonTextStyle)),
                          onPressed: () {
                            this.setState(() {});
                            Navigator.pop(dialogContext);
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(getSize(16)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                    color: CustomColors.secondaryColor)),
                            fixedSize: Size(
                                getHorizontalSize(100), getVerticalSize(20)),
                            backgroundColor: Colors.transparent,
                          ),
                          child: Center(
                              child: Text('Confirm',
                                  style: Styles.buttonTextStyle)),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                  content: Container(
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        'Are you sure you want to delete the Listing $name ?',
                        style: Styles.textWhite14,
                      ),
                    ),
                  )),
            );
          });
        });
  }
}
