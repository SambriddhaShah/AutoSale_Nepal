import 'dart:async';
import 'dart:io';

import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/BottomNavBar/BottomNavigationBar.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/BottomNavBar/NavItem/userPfofilePage.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/RegisterPage.dart';
import 'package:auto_sale_nepal/Utils/flutter_local_storage.dart';
import 'package:auto_sale_nepal/Utils/size_utils.dart';
import 'package:auto_sale_nepal/Utils/styles.dart';
import 'package:auto_sale_nepal/Utils/theme_helper.dart';
import 'package:auto_sale_nepal/Utils/toast_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SelectorPage extends StatefulWidget {
  static String routeName = "/selectorPage";

  const SelectorPage({super.key});

  @override
  State<SelectorPage> createState() => _SelectorPageState();
}

class _SelectorPageState extends State<SelectorPage> {
  bool _isChecked = false;
  bool _showPassword = false;
  String isAdmin = 'false';
  final _formKey = GlobalKey<FormState>();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    _loadUserNamePassword();
    super.initState();
  }

  // Load saved username and password
  void _loadUserNamePassword() async {
    try {
      await FlutterSecureData.getRememberMe().then((value) {
        setState(() {
          _isChecked = toBoolean(value.toString());
        });
      });
      if (await FlutterSecureData.getRememberMe() == "true") {
        userName.text = await FlutterSecureData.getUserName() ?? "";
      }
    } catch (e) {
      print(e);
    }
  }

  // Convert a string to a boolean value
  bool toBoolean(String string) {
    if (string == 'true') {
      return true;
    } else {
      return false;
    }
  }

  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              decoration:
                  const BoxDecoration(color: CustomColors.primaryColour),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2 -
                        getHorizontalSize(105),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/AutoSale Nepal-logos_transparent.png',
                          height: getVerticalSize(300),
                        )
                      ],
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height / 2 +
                          getHorizontalSize(105),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: CustomColors.secondaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign In',
                              style: Styles.textBlack32B,
                            ),
                            SizedBox(
                              height: getVerticalSize(40),
                            ),
                            // Text(
                            //   'Sign In',
                            //   style: Styles.textBlack32B,
                            // ),
                            SizedBox(
                              height: getVerticalSize(30),
                            ),
                            formlogin(),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     // Add your onPressed logic here
                            //   },
                            //   onLongPress: () {
                            //     // Add your onLongPress logic here
                            //   },
                            //   style: ButtonStyle(
                            //     fixedSize: MaterialStateProperty.all<Size>(
                            //       Size(
                            //           getHorizontalSize(150),
                            //           getVerticalSize(
                            //               50)), // Adjust the size as needed
                            //     ),
                            //     backgroundColor:
                            //         MaterialStateProperty.resolveWith<Color>(
                            //       (Set<MaterialState> states) {
                            //         if (states.contains(MaterialState.pressed)) {
                            //           // Button is being pressed, turn background color to red
                            //           return CustomColors.secondaryColor;
                            //         } else {
                            //           // Button is not pressed, default background color is white
                            //           return CustomColors.appColor;
                            //         }
                            //       },
                            //     ),
                            //     shape: MaterialStateProperty.all<
                            //         RoundedRectangleBorder>(
                            //       RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(
                            //             20.0), // Circular border radius
                            //         side: BorderSide(
                            //             width: getSize(4),
                            //             color: CustomColors
                            //                 .appColor), // Border width and color
                            //       ),
                            //     ),
                            //   ),
                            //   child: Padding(
                            //     padding: getMargin(),
                            //     child: Text(
                            //       'Sign In',
                            //       style: Styles.textWhite24,
                            //     ),
                            //   ),
                            // )
                          ]))
                ],
              )),
        ));
  }

  Widget formlogin() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                  getHorizontalSize(15), 0, getHorizontalSize(15), 0),
              decoration: ThemeHelper().inputBoxDecorationShaddow(),
              child: TextFormField(
                controller: userName,
                decoration: ThemeHelper()
                    .textInputDecoration('User Name', 'Enter your user name'),
                // onChanged: (String userName) {
                //   _userName = userName!;
                // },
                validator: (val) {
                  if ((val!.isEmpty) &&
                      !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                          .hasMatch(val)) {
                    return "Enter a valid email address";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.fromLTRB(
                  getHorizontalSize(15), 0, getHorizontalSize(15), 0),
              decoration: ThemeHelper().inputBoxDecorationShaddow(),
              child: TextFormField(
                  controller: password,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                        getHorizontalSize(20),
                        getVerticalSize(15),
                        getHorizontalSize(20),
                        getVerticalSize(15)),
                    hintText: "Password",
                    hintStyle: Styles.textBlack16,
                    labelStyle: Styles.textBlack16,
                    fillColor: Colors.white,
                    labelText: "Password",
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: CustomColors.inputTextBoarder)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: CustomColors.inputTextErrorBoarder,
                            width: 2.0)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: CustomColors.inputTextErrorBoarder,
                            width: 2.0)),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _togglevisibility();
                      },
                      child: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: CustomColors.appColor),
                    ),
                  ),
                  // onChanged: (String password) {
                  //   _password = password!;
                  // },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please enter your Password';
                    } else if (!RegExp(
                            r"^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,}$|^[a-zA-Z0-9!@#$%^&*()_+{}|:<>?~-]{4,}$")

                        // RegExp(
                        //         r"^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,}$")
                        .hasMatch(val)) {
                      return "Please Enter a Valid Password";
                    }
                  }),
            ),
            const SizedBox(height: 5.0),
            Row(
              children: <Widget>[
                Checkbox(
                    activeColor: CustomColors.appColor,
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = !_isChecked;
                        _handleRememberMe(
                            _isChecked, userName.text, password.text);
                      });
                    }),
                Text(
                  "Remember me",
                  style: Styles.textBlack18,
                )
              ],
            ),
            const SizedBox(height: 5.0),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/forgotpassword');
                },
                child: Text(
                  "Forgot your password?",
                  style: Styles.textBlack18,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              width: 263,
              height: 65,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          // Button is being pressed, turn background color to red
                          return CustomColors.appColor;
                        } else {
                          // Button is not pressed, default background color is white
                          return Colors.white;
                        }
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(33.0),
                    ))),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                  child: Text('Sign in', style: Styles.textBlack24B),
                ),
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {}
                  // _handleRememberMe(_isChecked, userName.text, password.text);
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(
                  //     builder: (context) => BottomNavBar(),
                  //   ),
                  // );

                  if (_formKey.currentState!.validate()) {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: userName.text, password: password.text)
                        .then((value) async {
                      var valuee = await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(value.user!.uid)
                          .get();
                      if (valuee.exists) {
                        setState(() {
                          isAdmin = valuee.data()!['isAdmin'];
                        });
                        print('the is admin is $isAdmin');
                        _handleRememberMe(
                            _isChecked, userName.text, password.text);
                        FlutterSecureData.setUserUid(
                            FirebaseAuth.instance.currentUser!.uid);

                        ToastMessage.showMessage('Logged In Successfully');
                        // ignore: use_build_context_synchronously
                        isAdmin != 'true'
                            ? Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BottomNavBar(),
                                ),
                              )
                            : Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(),
                                ),
                              );
                      } else {
                        ToastMessage.showMessage('Account not Found');
                      }
                    }).onError((error, stackTrace) {
                      print('Error: ${error.toString()}');
                      ToastMessage.showMessage(error.toString());
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter all essentials'),
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 15),
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: r"Don\'t have an account? ",
                    style: Styles.textBlack18),
                TextSpan(
                    text: 'Create',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ));
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             OtpVerification( )));
                      },
                    style: Styles.textBlueStyle),
              ])),
            ),
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Platform.isIOS == true
            //           ? GestureDetector(
            //               child: const Image(
            //                 image: AssetImage("assets/images/apple_logo.png"),
            //                 height: 40.0,
            //                 width: 30,
            //               ),
            //               onTap: () async {
            //                 // SocialMediaLoginRequest sloginRequest =
            //                 //     SocialMediaLoginRequest();
            //                 // SignInWithApple.getAppleIDCredential(scopes: [
            //                 //   AppleIDAuthorizationScopes.email,
            //                 //   AppleIDAuthorizationScopes.fullName
            //                 // ]).then((result) async {
            //                 //   //print(result);
            //                 //   if (result.userIdentifier != null) {
            //                 //     final uIdentifier =
            //                 //         result.userIdentifier?.replaceAll(".", "");
            //                 //     //print(uIdentifier);
            //                 //     final appleLoginRes =
            //                 //         await FlutterSecureData.readAppleLogin(
            //                 //             uIdentifier!);
            //                 //     //print(appleLoginRes?.toJson());
            //                 //     if (result.email != null &&
            //                 //         appleLoginRes == null) {
            //                 //       var appleLoginResponse = AppleLoginReponseDTO();
            //                 //       appleLoginResponse.email = result.email;
            //                 //       appleLoginResponse.userIdentifier =
            //                 //           result.userIdentifier;
            //                 //       appleLoginResponse.givenName = result.givenName;
            //                 //       appleLoginResponse.familyName =
            //                 //           result.familyName;
            //                 //       FlutterSecureData.saveAppleLogin(
            //                 //           appleLoginResponse, uIdentifier!);
            //                 //     }

            //                 //     SignInWithApple.getCredentialState(
            //                 //             result.userIdentifier.toString())
            //                 //         .then((data) {
            //                 //       sloginRequest = SocialMediaLoginRequest(
            //                 //         name: appleLoginRes != null &&
            //                 //                 appleLoginRes.givenName != null
            //                 //             ? appleLoginRes.givenName.toString()
            //                 //             : result.givenName.toString() +
            //                 //                 " " +
            //                 //                 (appleLoginRes != null &&
            //                 //                         appleLoginRes.familyName !=
            //                 //                             null
            //                 //                     ? appleLoginRes.familyName
            //                 //                         .toString()
            //                 //                     : result.familyName.toString()),
            //                 //         email: appleLoginRes != null &&
            //                 //                 appleLoginRes.email != null
            //                 //             ? appleLoginRes.email.toString()
            //                 //             : result.email,
            //                 //         id: result.userIdentifier,
            //                 //         idToken: "", //result.identityToken,
            //                 //         isMobile: true,
            //                 //         token: result.authorizationCode,
            //                 //         clientId: APPDATA.CLIENTID,
            //                 //         clientSecret: APPDATA.CLIENTSECRET,
            //                 //         loginProvider: APPDATA.APPLELOGINPROVIDER,
            //                 //         scope: APPDATA.SCOPE,
            //                 //         grant_Type: APPDATA.GRANT_TYPE,
            //                 //         deviceToken: userAuthKey.deviceToken,
            //                 //         deviceType: userAuthKey.deviceType,
            //                 //       );
            //                 //       //print(sloginRequest.toJson());
            //                 //       BlocProvider.of<LoginSocialAuthBlock>(context)
            //                 //           .add(LoginSocial(sloginRequest));
            //                 //     });
            //                 //   }
            //                 // });
            //               })
            //           : SizedBox.shrink(),
            //       Platform.isIOS == true
            //           ? SizedBox(
            //               width: getHorizontalSize(20),
            //             )
            //           : const SizedBox.shrink(),
            //       //googleLogin(userAuthKey),

            //       GestureDetector(
            //           child: const Image(
            //             image: AssetImage("assets/images/google.jpg"),
            //             height: 40.0,
            //             width: 30,
            //           ),
            //           onTap: () async {
            //             // SocialMediaLoginRequest sloginRequest =
            //             //     SocialMediaLoginRequest();
            //             // globals.googleSignIn.signIn().then((result) async {
            //             //   email = result!.email;
            //             //   if (result != null) {
            //             //     result.authentication.then((data) {
            //             //       sloginRequest = SocialMediaLoginRequest(
            //             //         name: result.displayName,
            //             //         email: result.email,
            //             //         id: result.id,
            //             //         idToken: data.idToken,
            //             //         isMobile: true,
            //             //         token: data.accessToken,
            //             //         clientId: APPDATA.CLIENTID,
            //             //         clientSecret: APPDATA.CLIENTSECRET,
            //             //         loginProvider: APPDATA.GOOGLELOGINPROVIDER,
            //             //         scope: APPDATA.SCOPE,
            //             //         grant_Type: APPDATA.GRANT_TYPE,
            //             //         deviceToken: userAuthKey.deviceToken,
            //             //         deviceType: userAuthKey.deviceType,
            //             //       );
            //             //       BlocProvider.of<LoginSocialAuthBlock>(context)
            //             //           .add(LoginSocial(sloginRequest));
            //             //     });
            //             // }
            //             // });
            //           }),
            //       const SizedBox(
            //         width: 0.0,
            //       ),
            //       const SizedBox(
            //         width: 20.0,
            //         //width: 30.0,
            //       ),
            //       GestureDetector(
            //         child: const Image(
            //           image: AssetImage("assets/images/facebook.jpg"),
            //           height: 40.0,
            //           width: 30,
            //         ),
            //         onTap: () {
            //           // SocialMediaLoginRequest socLoginRequest =
            //           //     SocialMediaLoginRequest();
            //           // FacebookAuth.instance.login(
            //           //     permissions: ['public_profile', 'email']).then((value) {
            //           //   FacebookAuth.instance
            //           //       .getUserData()
            //           //       .then((userdata) async {
            //           //     email = userdata['email'];
            //           //     socLoginRequest = SocialMediaLoginRequest(
            //           //       name: userdata['name'],
            //           //       email: userdata['email'],
            //           //       id: userdata['id'],
            //           //       isMobile: true,
            //           //       idToken: value.accessToken!.token,
            //           //       token: value.accessToken!.token,
            //           //       clientId: APPDATA.CLIENTID,
            //           //       clientSecret: APPDATA.CLIENTSECRET,
            //           //       loginProvider: APPDATA.FACEBOOKLOGINPROVIDER,
            //           //       scope: APPDATA.SCOPE,
            //           //       grant_Type: APPDATA.GRANT_TYPE,
            //           //       deviceToken: userAuthKey!.deviceToken,
            //           //       deviceType: userAuthKey!.deviceType,
            //           //     );
            //           //     BlocProvider.of<LoginSocialAuthBlock>(context)
            //           //         .add(LoginSocial(socLoginRequest));
            //           // });
            //           // });
            //         },
            //       ),
            //     ],
            //   ),
          ],
        ));
  }

  void _handleRememberMe(
    bool value,
    String username,
    String password,
  ) async {
    // print("${value.toString()} ====--=== $_isChecked |||| ${username.isNotEmpty} && ${password.isNotEmpty}");
    if (_isChecked || value) {
      await FlutterSecureData.setUserName(username);
      await FlutterSecureData.setPassword(password);
      await FlutterSecureData.setRememberMe(
          username.isNotEmpty && password.isNotEmpty ? true : false);
    } else {
      await FlutterSecureData.setRememberMe(value);
      await FlutterSecureData.deletePassword();
    }
    //print("=-=-=-=-= ${await FlutterSecureData.getUserName()}==${await FlutterSecureData.getRememberMe()}");
  }
}
