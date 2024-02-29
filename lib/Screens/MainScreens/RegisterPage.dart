import 'dart:io';
import 'dart:typed_data';

import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/BottomNavBar/BottomNavigationBar.dart';
import 'package:auto_sale_nepal/Utils/flutter_local_storage.dart';
import 'package:auto_sale_nepal/Utils/size_utils.dart';
import 'package:auto_sale_nepal/Utils/styles.dart';
import 'package:auto_sale_nepal/Utils/theme_helper.dart';
import 'package:auto_sale_nepal/Utils/toast_message.dart';
import 'package:auto_sale_nepal/profileImage/save_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final double _headerHeight = 200;
  bool checkedValue = false;
  bool checkboxValue = false;
  late TextEditingController email;
  late TextEditingController firstName;
  late TextEditingController lastName;
  late TextEditingController phoneNumber;
  late TextEditingController password;
  bool _isChecked = false;
  bool _showPassword = false;
  XFile? file;

  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<String> saveProfileImage() async {
    String resp = await StoreData().saveData(file: _image!);
    return resp;
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    file = await _imagePicker.pickImage(source: source);
    if (file != null) {
      return await file!.readAsBytes();
    }
    print("No image Selected");
  }

  @override
  void initState() {
    super.initState();
    // registrationRequest = RegistrationRequest();
    // userAuthKey = globals.userAuthKey;
    // _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
    //   setState(() {
    //     _currentUser = account;
    //   });
    //   print(_currentUser);
    // });
    // _googleSignIn.signInSilently();

    email = TextEditingController();
    firstName = TextEditingController();
    lastName = TextEditingController();
    phoneNumber = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    firstName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: CustomColors.appColor,
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        getHorizontalSize(15), 0, getHorizontalSize(15), 0),
                    width: MediaQuery.of(context).size.width -
                        getHorizontalSize(30),
                    // height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: getVerticalSize(40),
                        ),
                        Text(
                          'Register',
                          style: Styles.textBlack32B,
                        ),
                        SizedBox(
                          height: getVerticalSize(25),
                        ),
                        Stack(
                          children: [
                            _image != null
                                ? CircleAvatar(
                                    radius: getSize(80),
                                    backgroundImage: MemoryImage(_image!),
                                  )
                                : CircleAvatar(
                                    radius: getSize(80),
                                    backgroundImage: const AssetImage(
                                        'assets/images/defaultProfile.png'),
                                  ),
                            Positioned(
                              bottom: getVerticalSize(-10),
                              left: getHorizontalSize(80),
                              child: IconButton(
                                  onPressed: selectImage,
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    size: getSize(35),
                                    color: CustomColors.appColor,
                                  )),
                            )
                          ],
                        ),
                        SignUpForm(),
                      ],
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  Widget SignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: getVerticalSize(20),
          ),
          Container(
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
            child: TextFormField(
              controller: email,
              decoration: ThemeHelper()
                  .textInputDecoration("E-mail address ", "Enter your email "),
              keyboardType: TextInputType.emailAddress,
              // onChanged: (String email) {
              //   _email = email;
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

          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
            child: TextFormField(
              controller: firstName,
              decoration: ThemeHelper()
                  .textInputDecoration('First Name', 'Enter your first name'),
              // onChanged: (String firstName) {
              //   _firstName = firstName!;
              // },
              validator: (val) {
                if (val!.isEmpty) {
                  return "Please enter your First Name";
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
            child: TextFormField(
              controller: lastName,
              decoration: ThemeHelper()
                  .textInputDecoration('Last Name', 'Enter your last name'),
              // onChanged: (String lastName) {
              //   _lastName = lastName!;
              // },
              validator: (val) {
                if (val!.isEmpty) {
                  return "Please enter your Last Name";
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20.0),

          Container(
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
            child: TextFormField(
              controller: phoneNumber,
              decoration: ThemeHelper().textInputDecoration(
                  "Phone Number", "Enter your phone number"),
              keyboardType: TextInputType.number,
              // onChanged: (String phoneNumber) {
              //   _phoneNumber = phoneNumber!;
              // },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please Enter a Phone Number";
                } else if (!RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(value)) {
                  return "Please Enter a Valid Phone Number";
                }
              },
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
            child: TextFormField(
                controller: password,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                        color: CustomColors.appColor),
                  ),
                ),
                // onChanged: (String password) {
                //   _password = password!;
                // },
                validator: (val) {
                  if (val!.isEmpty)
                    return 'Please enter your Password';
                  else if (!RegExp(r"^[a-zA-Z0-9!@#$%^&*()_+{}|:<>?~-]{4,}$")
                      // !RegExp(
                      //       r"^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,}$")
                      .hasMatch(val)) {
                    return "Please Enter a Valid Password";
                  }
                }),
          ),

          const SizedBox(height: 15.0),

          const SizedBox(height: 20.0),
          Container(
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
                padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                child: Text(
                  "Register",
                  style: Styles.textBlack24B,
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_image != null) {
                    registerUserimage('');
                  } else {
                    registerUser('');
                  }

                  //             Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => DashboardPage()),
                  // );
                } else {
                  ToastMessage.showMessage(
                      "Enter all essential data correctly");
                }
                // if (_formKey.currentState!.validate()) {
                //   registrationRequest = RegistrationRequest(
                //     email: email.text.trim(),
                //     password: password.text.trim(),
                //     firstName: firstName.text.trim(),
                //     lastName: lastName.text.trim(),
                //     phoneNumber: phoneNumber.text.trim(),
                //   );
                //   BlocProvider.of<RegistrationBloc>(context).add(Registration(
                //     email: email.text.trim(),
                //     password: password.text.trim(),
                //     firstName: firstName.text.trim(),
                //     lastName: lastName.text.trim(),
                //     phoneNumber: phoneNumber.text.trim(),
                //   ));

                //   // Navigator.of(context).pushAndRemoveUntil(
                //   //     MaterialPageRoute(
                //   //         builder: (context) => ProfilePage()),
                //   //     (Route<dynamic> route) => false);
                // }
              },
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 15),
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: r"Already have an account? ",
                  style: Styles.textBlack18),
              TextSpan(
                  text: 'Sign In',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pop();
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             OtpVerification( )));
                    },
                  style: Styles.textBlueStyle),
            ])),
          ),
          const SizedBox(height: 15.0),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     googleLogin(widget.userAuthKey!),
          //     const SizedBox(
          //       width: 30.0,
          //     ),
          //     _fbLogin(widget.userAuthKey!)
          //   ],
          // ),

          //_fbLogin(widget.userAuthKey!),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Platform.isIOS == true
          //         ? GestureDetector(
          //             child: const Image(
          //               image: AssetImage("assets/images/apple_logo.png"),
          //               height: 40.0,
          //               width: 30,
          //             ),
          //             onTap: () async {
          //               // SocialMediaLoginRequest sloginRequest =
          //               //     SocialMediaLoginRequest();
          //               // SignInWithApple.getAppleIDCredential(scopes: [
          //               //   AppleIDAuthorizationScopes.email,
          //               //   AppleIDAuthorizationScopes.fullName
          //               // ]).then((result) async {
          //               //   //print(result);
          //               //   if (result.userIdentifier != null) {
          //               //     final uIdentifier =
          //               //         result.userIdentifier?.replaceAll(".", "");
          //               //     //print(uIdentifier);
          //               //     final appleLoginRes =
          //               //         await FlutterSecureData.readAppleLogin(
          //               //             uIdentifier!);
          //               //     //print(appleLoginRes?.toJson());
          //               //     if (result.email != null && appleLoginRes == null) {
          //               //       var appleLoginResponse = AppleLoginReponseDTO();
          //               //       appleLoginResponse.email = result.email;
          //               //       appleLoginResponse.userIdentifier =
          //               //           result.userIdentifier;
          //               //       appleLoginResponse.givenName = result.givenName;
          //               //       appleLoginResponse.familyName = result.familyName;
          //               //       FlutterSecureData.saveAppleLogin(
          //               //           appleLoginResponse, uIdentifier!);
          //               //     }

          //               //     SignInWithApple.getCredentialState(
          //               //             result.userIdentifier.toString())
          //               //         .then((data) {
          //               //       sloginRequest = SocialMediaLoginRequest(
          //               //         name: appleLoginRes != null &&
          //               //                 appleLoginRes.givenName != null
          //               //             ? appleLoginRes.givenName.toString()
          //               //             : result.givenName.toString() +
          //               //                 " " +
          //               //                 (appleLoginRes != null &&
          //               //                         appleLoginRes.familyName != null
          //               //                     ? appleLoginRes.familyName
          //               //                         .toString()
          //               //                     : result.familyName.toString()),
          //               //         email: appleLoginRes != null &&
          //               //                 appleLoginRes.email != null
          //               //             ? appleLoginRes.email.toString()
          //               //             : result.email,
          //               //         id: result.userIdentifier,
          //               //         idToken: "", //result.identityToken,
          //               //         isMobile: true,
          //               //         token: result.authorizationCode,
          //               //         clientId: APPDATA.CLIENTID,
          //               //         clientSecret: APPDATA.CLIENTSECRET,
          //               //         loginProvider: APPDATA.APPLELOGINPROVIDER,
          //               //         scope: APPDATA.SCOPE,
          //               //         grant_Type: APPDATA.GRANT_TYPE,
          //               //         deviceToken: userAuthKey.deviceToken,
          //               //         deviceType: userAuthKey.deviceType,
          //               //       );
          //               //       //print(sloginRequest.toJson());
          //               //       BlocProvider.of<LoginSocialAuthBlock>(context)
          //               //           .add(LoginSocial(sloginRequest));
          //               //     });
          //               // }
          //               // });
          //             })
          //         : SizedBox.shrink(),
          //     Platform.isIOS == true
          //         ? SizedBox(
          //             width: getHorizontalSize(20),
          //           )
          //         : const SizedBox.shrink(),
          //     //googleLogin(userAuthKey),
          //     GestureDetector(
          //         child: const Image(
          //           image: AssetImage("assets/images/google.jpg"),
          //           height: 40.0,
          //           width: 30,
          //         ),
          //         onTap: () {
          //           // SocialMediaLoginRequest sloginRequest =
          //           //     SocialMediaLoginRequest();
          //           // globals.googleSignIn.signIn().then((result) async {
          //           //   email = result!.email;
          //           //   if (result != null) {
          //           //     result.authentication.then((data) {
          //           //       sloginRequest = SocialMediaLoginRequest(
          //           //         name: result.displayName,
          //           //         email: result.email,
          //           //         id: result.id,
          //           //         idToken: data.idToken,
          //           //         isMobile: true,
          //           //         token: data.accessToken,
          //           //         clientId: APPDATA.CLIENTID,
          //           //         clientSecret: APPDATA.CLIENTSECRET,
          //           //         loginProvider: APPDATA.GOOGLELOGINPROVIDER,
          //           //         scope: APPDATA.SCOPE,
          //           //         grant_Type: APPDATA.GRANT_TYPE,
          //           //         deviceToken: userAuthKey.deviceToken,
          //           //         deviceType: userAuthKey.deviceType,
          //           //       );
          //           //       BlocProvider.of<LoginSocialAuthBlock>(context)
          //           //           .add(LoginSocial(sloginRequest));
          //           //     });
          //           //   }
          //           // });
          //         }),
          //     const SizedBox(
          //       width: 0.0,
          //     ),
          //     const SizedBox(
          //       width: 30.0,
          //     ),
          //     GestureDetector(
          //       child: const Image(
          //         image: AssetImage("assets/images/facebook.jpg"),
          //         height: 40.0,
          //         width: 30,
          //       ),
          //       onTap: () {
          //         // SocialMediaLoginRequest socLoginRequest =
          //         //     SocialMediaLoginRequest();
          //         // FacebookAuth.instance.login(
          //         //     permissions: ['public_profile', 'email']).then((value) {
          //         //   FacebookAuth.instance.getUserData().then((userdata) async {
          //         //     email = userdata['email'];
          //         //     socLoginRequest = SocialMediaLoginRequest(
          //         //       name: userdata['name'],
          //         //       email: userdata['email'],
          //         //       id: userdata['id'],
          //         //       isMobile: true,
          //         //       idToken: value.accessToken!.token,
          //         //       token: value.accessToken!.token,
          //         //       clientId: APPDATA.CLIENTID,
          //         //       clientSecret: APPDATA.CLIENTSECRET,
          //         //       loginProvider: APPDATA.FACEBOOKLOGINPROVIDER,
          //         //       scope: APPDATA.SCOPE,
          //         //       grant_Type: APPDATA.GRANT_TYPE,
          //         //       deviceToken: userAuthKey!.deviceToken,
          //         //       deviceType: userAuthKey!.deviceType,
          //         //     );
          //         //     BlocProvider.of<LoginSocialAuthBlock>(context)
          //         //         .add(LoginSocial(socLoginRequest));
          //         //   });
          //         // });
          //       },
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 60.0),
        ],
      ),
    );
  }

  Future registerUser(String url) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = FirebaseAuth.instance.currentUser;

    auth
        .createUserWithEmailAndPassword(
            email: email.text, password: password.text)
        .then((signedInUser) => FirebaseFirestore.instance
                .collection("Users")
                .doc(signedInUser.user!.uid)
                .set({
              "name": firstName.text + lastName.text,
              "email": email.text,
              "Phone": phoneNumber.text,
              // 'Date of Birth': dateController.text,
              'imageLink': url,
              'isAdmin': 'false'
            }))
        .then((value) {
      FlutterSecureData.setUserUid(FirebaseAuth.instance.currentUser!.uid);
      print('created a new account');
      ToastMessage.showMessage('Account Created Sucessfully');

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BottomNavBar(),
      ));
    }).onError((error, stackTrace) {
      print('Error ${error.toString()}');
      Fluttertoast.showToast(msg: error.toString());
    });
  }

  Future registerUserimage(String url) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = FirebaseAuth.instance.currentUser;

    auth
        .createUserWithEmailAndPassword(
            email: email.text, password: password.text)
        .then((signedInUser) {
      saveProfileImage().then((value) => {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(signedInUser.user!.uid)
                .set({
              "name": firstName.text + lastName.text,
              "email": email.text,
              "Phone": phoneNumber.text,
              // 'Date of Birth': dateController.text,
              'imageLink': value,
              'isAdmin': 'false'
            })
          });
    }).then((value) {
      FlutterSecureData.setUserUid(FirebaseAuth.instance.currentUser!.uid);
      print('created a new account');
      ToastMessage.showMessage('Account Created Sucessfully');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BottomNavBar(),
      ));
    }).onError((error, stackTrace) {
      print('Error ${error.toString()}');
      Fluttertoast.showToast(msg: error.toString());
    });
  }
}
