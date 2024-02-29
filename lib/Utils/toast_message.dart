// Import necessary packages and modules
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

import '../constants/customColors.dart';

// Define a class for displaying toast messages
class ToastMessage {
  // Static method to show a toast message
  static showMessage(String message) {
    Fluttertoast.showToast(
        backgroundColor: CustomColors.primaryColour,
        msg: message,
        textColor: CustomColors.secondaryColor,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 15);
  }

  // Static method to show a SnackBar using ScaffoldMessenger
  static ScaffoldFeatureController scaffoldMessenger(
          BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: CustomColors.primaryColour,
        content: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * .2,
            child: Row(children: [
              Image.asset('assets/icons/AutoSale Nepal-logos_transparent.png'),
              Text(
                message,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.secondaryColor),
              ),
            ])),
      ));
}
