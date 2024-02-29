import 'dart:async';

import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Firebase/approvedListingsModel.dart';
import 'package:auto_sale_nepal/Firebase/service.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/Drawer/drawerPage.dart';
import 'package:auto_sale_nepal/Utils/size_utils.dart';
import 'package:auto_sale_nepal/Utils/styles.dart';
import 'package:auto_sale_nepal/Utils/toast_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class PaymentPage extends StatefulWidget {
  List data;
  PaymentPage({super.key, required this.data});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  ApprovedListing? data;
  String? sellername;
  String? sellerphone;
  var config;
  String? phone;

  @override
  void initState() {
    data = widget.data[0];
    sellername = widget.data[1];
    sellerphone = widget.data[2];
    getUserData(data!.purchaserequests);
    setConfig();
    super.initState();
  }

  void setConfig() {
    setState(() {
      final config = PaymentConfig(
        amount: 10000, // Amount should be in paisa
        productIdentity: data!.id,
        productName: data!.name,
        productUrl: 'https://www.khalti.com/#/bazaar',
        additionalData: {
          // Not mandatory; can be used for reporting purpose
          'vendor': sellername!,
        },
        // mobile:
        //     '9800000001', // Not mandatory; can be used to fill mobile number field
        // mobileReadOnly:
        //     true, // Not mandatory; makes the mobile field not editable
      );
    });
  }

  // getting user data from the firebase and showing in the application
  void getUserData(String id) async {
    var value =
        await FirebaseFirestore.instance.collection("Users").doc(id).get();
    if (value.exists) {
      setState(() {
        phone = value.data()!['Phone'];
      });
    }
  }

  @override
  void dispose() {
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
      body: Container(
        //decoration: BoxDecoration(color: CustomColors.appColor),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
            children: [Text("Payment Page", style: Styles.textBlack24B)],
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
              child: Container(
            width: MediaQuery.of(context).size.width - 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Summary of Purchase',
                      style: Styles.textBlack20B,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5),
                      border: Border.all(color: CustomColors.appColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name of Vehicle:",
                              style: Styles.textBlack15BNormal,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Seller's Name :",
                              style: Styles.textBlack15BNormal,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Brand :",
                              style: Styles.textBlack15BNormal,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Price :",
                              style: Styles.textBlack15BNormal,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data!.name,
                            // "Total Km's :",
                            style: Styles.textBlack15BNormal,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            // "Total Owners :",
                            sellername!,
                            style: Styles.textBlack15BNormal,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            // "Brand :",
                            data!.brand,
                            style: Styles.textBlack15BNormal,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            // "Vehicle's name :",
                            "Rs. ${data!.price}",
                            style: Styles.textBlack15BNormal,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    KhaltiScope.of(context).pay(
                      config: PaymentConfig(
                        amount: 10000,
                        // int.parse(data!.price) *
                        //     100, // Amount should be in paisa
                        productIdentity: data!.id,
                        productName: data!.name,
                        productUrl: 'https://www.khalti.com/#/bazaar',
                        additionalData: {
                          // Not mandatory; can be used for reporting purpose
                          'vendor': sellername!,
                        },
                        mobile:
                            phone, // Not mandatory; can be used to fill mobile number field
                        // mobileReadOnly:
                        //     true, // Not mandatory; makes the mobile field not editable
                      ),
                      // preferences: [
                      //   PaymentPreference.connectIPS,
                      //   PaymentPreference.eBanking,
                      //   PaymentPreference.sct,
                      // ],
                      onSuccess: (value) {
                        ToastMessage.showMessage('Paayment Sucessfull');
                        FirebaseService.updateApprovedListingParameter(
                                data!.id, "isPaid", 'true')
                            .then((value) => {
                                  Navigator.of(context).pop(),
                                })
                            .catchError((error) {
                          ToastMessage.showMessage('Cannot Fulfill Request');
                        });
                      },
                      onFailure: (value) {
                        ToastMessage.showMessage('Payment Failed');
                      },
                      onCancel: () {
                        ToastMessage.showMessage('Payment Cancelled');
                      },
                    );
                  },
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.5),
                        color: CustomColors.appColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: CircleAvatar(
                              radius: 30,
                              child: Image.asset(
                                  'assets/images/Khalti_Digital_Wallet_Logo.png')),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Text(
                            'Pay Via Khalti',
                            style: Styles.textWhite26,
                          ),
                        ),
                        Icon(
                          Icons.forward,
                          color: CustomColors.secondaryColor,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    FirebaseService.updateApprovedListingParameter(
                            data!.id, "isCOD", 'true')
                        .then((value) => {
                              Navigator.of(context).pop(),
                            })
                        .catchError((error) {
                      ToastMessage.showMessage('Cannot Fulfill Request');
                    });
                  },
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.5),
                        color: CustomColors.appColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: CircleAvatar(
                              radius: 30,
                              child: Image.asset('assets/images/1554401.png')),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Text(
                            'Cash On Meet',
                            style: Styles.textWhite26,
                          ),
                        ),
                        Icon(
                          Icons.forward,
                          color: CustomColors.secondaryColor,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ))
        ]),
      ),
    );
  }

  // void showDialogue(BuildContext context1, String name, String id) {
  //   BuildContext dialogContext;

  //   showDialog(
  //       context: context1,
  //       builder: (BuildContext context) {
  //         dialogContext = context; // Capture the context

  //         // ... other dialog code

  //         return StatefulBuilder(builder: (context, setState) {
  //           // ignore: deprecated_member_use
  //           return WillPopScope(
  //             onWillPop: () async {
  //               // Use the captured context here
  //               return false;
  //               // ... handle pop scope logic
  //             },
  //             child: AlertDialog(
  //                 backgroundColor: CustomColors.appColor,
  //                 title: Text(
  //                   'Delete Listing',
  //                   style: Styles.textWhite24,
  //                 ),
  //                 actions: [
  //                   Row(
  //                     children: [
  //                       ElevatedButton(
  //                         style: ElevatedButton.styleFrom(
  //                           padding: EdgeInsets.all(getSize(16)),
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(15),
  //                               side: BorderSide(
  //                                   color: CustomColors.secondaryColor)),
  //                           fixedSize: Size(
  //                               getHorizontalSize(100), getVerticalSize(20)),
  //                           backgroundColor: Colors.transparent,
  //                         ),
  //                         child: Center(
  //                             child: Text('Discard',
  //                                 style: Styles.buttonTextStyle)),
  //                         onPressed: () {
  //                           this.setState(() {});
  //                           Navigator.pop(dialogContext);
  //                         },
  //                       ),
  //                       SizedBox(
  //                         width: 15,
  //                       ),
  //                       ElevatedButton(
  //                         style: ElevatedButton.styleFrom(
  //                           padding: EdgeInsets.all(getSize(16)),
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(15),
  //                               side: BorderSide(
  //                                   color: CustomColors.secondaryColor)),
  //                           fixedSize: Size(
  //                               getHorizontalSize(100), getVerticalSize(20)),
  //                           backgroundColor: Colors.transparent,
  //                         ),
  //                         child: Center(
  //                             child: Text('Confirm',
  //                                 style: Styles.buttonTextStyle)),
  //                         onPressed: () {
  //                           FirebaseService.deleteListing(id)
  //                               .then((value) => {
  //                                     setmyData(),
  //                                     ToastMessage.showMessage(
  //                                         'Listing deleted')
  //                                   })
  //                               .catchError((error) {
  //                             ToastMessage.showMessage('Error: $error');
  //                           });
  //                           this.setState(() {});
  //                           Navigator.pop(dialogContext);
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //                 content: Container(
  //                   height: 40,
  //                   child: Padding(
  //                     padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
  //                     child: Text(
  //                       'Are you sure you want to delete the Listing $name ?',
  //                       style: Styles.textWhite14,
  //                     ),
  //                   ),
  //                 )),
  //           );
  //         });
  //       });
  // }
}
