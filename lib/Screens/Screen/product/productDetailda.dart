import 'dart:async';

import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Firebase/ListingsModel.dart';
import 'package:auto_sale_nepal/Firebase/service.dart';
import 'package:auto_sale_nepal/Utils/size_utils.dart';
import 'package:auto_sale_nepal/Utils/styles.dart';
import 'package:auto_sale_nepal/Utils/toast_message.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetailsView extends StatefulWidget {
  Listing data;
  ProductDetailsView({super.key, required this.data});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final controller = CarouselController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _imageUrls = [
    // Add more image URLs as needed
  ];
  Listing? data;
  int currentIndex = 0;
  bool isShow = true;
  bool isShoww = true;
  bool isShowww = true;
  String isAdmin = 'false';
  String? name;
  String? phone;
  String? imageUrl;
  String currentUser = FirebaseAuth.instance.currentUser!.uid.toString();
  bool isSent = false;
  StreamSubscription<Listing?>? _listingsSubscription;

  @override
  TextEditingController searchProduct = TextEditingController();
  void initState() {
    getAdmin();
    data = widget.data;
    _imageUrls = data!.imageLinks;
    setIsSent();
    getUserData(data!.userId);
    super.initState();
  }

  Future<void> getAdmin() async {
    var valuee = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (valuee.exists) {
      setState(() {
        isAdmin = valuee.data()!['isAdmin'];
      });
    } else {
      setState(() {
        isAdmin = '';
      });
      // ToastMessage.showMessage('No User Found');
    }
  }

  void setmyDatanew() {
    // Assuming this is in the main method or initState() of a StatefulWidget
    _listingsSubscription = FirebaseService.getListingById(data!.id!).listen(
      (listings) {
        // Update the variable with the latest data
        var lsit = listings;
        setState(() {
          data = lsit;
          print('the new data is $lsit');
          _listingsSubscription?.cancel();
          setIsSent();
        });
      },
      onError: (error) {
        // Handle any errors
        print('Error fetching listings: $error');
        ToastMessage.showMessage('error occured fetching data $error');
      },
    );
  }

  void setIsSent() {
    // print('the purchase request list is ${data!.purchaserequests}');
    // print('the result is ${data!.purchaserequests.contains(currentUser)}');
    if (data!.purchaserequests.contains(currentUser) == true) {
      print('here it came in true');
      setState(() {
        isSent = true;
      });
    } else {
      print('here it came at false');
      setState(() {
        isSent = false;
      });
    }
  }

  // getting user data from the firebase and showing in the application
  void getUserData(String id) async {
    var value =
        await FirebaseFirestore.instance.collection("Users").doc(id).get();
    if (value.exists) {
      setState(() {
        name = value.data()!['name'];
        // email = value.data()!['email'];
        phone = value.data()!['Phone'];
        imageUrl = value.data()!['imageLink'];
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
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
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
        body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Stack(
              children: [
                Container(
                  color: CustomColors.appColor,
                  height: MediaQuery.of(context).size.height * 0.39,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.39,
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
                Positioned(
                  top: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: CarouselSlider.builder(
                        carouselController: controller,
                        itemCount: _imageUrls.length,
                        itemBuilder: (context, index, realIndex) {
                          return Stack(children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.38,
                                margin: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: CustomColors.appColor,
                                  image: DecorationImage(
                                    image: NetworkImage(_imageUrls[index]),
                                    fit: BoxFit
                                        .cover, // Adjust the fit property as needed
                                  ),
                                ),
                              ),
                            ),
                          ]);
                        },
                        options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.38,
                            aspectRatio: getHorizontalSize(
                                350), // Adjust the aspect ratio
                            viewportFraction: 1.0, //
                            // autoPlay: true,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                const Duration(seconds: 2),
                            autoPlay: true,
                            // enlargeCenterPage: true,
                            onPageChanged: (index, reason) =>
                                setState(() => currentIndex = index))),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            // AnimatedSmoothIndicator(
            //   activeIndex: currentIndex,
            //   count: _imageUrls.length,

            //   effect: WormEffect(),
            // ),

            //  Most Popular Listings
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Text(data!.name, style: Styles.textBlack32B),
                    ),
                  ),
                ),
                // IconButton(
                //   // padding: const EdgeInsets.only(right: 25),
                //   icon: const Icon(
                //     Icons.expand_more,
                //     size: 30,
                //     color: Colors.orange,
                //   ),
                //   highlightColor: Colors.orangeAccent,
                //   onPressed: () {
                //     Navigator.of(context).pushNamed('/moremostpopular');
                //   },
                // ),
              ],
            ),

            //  Most newest Listings
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Text('Description', style: Styles.textBlack24B),
                    ),
                  ),
                ),
                IconButton(
                  // padding: const EdgeInsets.only(right: 25),
                  icon: Icon(
                    isShow == true
                        ? Icons.expand_more
                        : Icons.expand_less_outlined,
                    size: 30,
                    color: Colors.orange,
                  ),
                  highlightColor: Colors.orangeAccent,
                  onPressed: () {
                    setState(() {
                      isShow = !isShow;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            isShow == true
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.5),
                        border: Border.all(color: CustomColors.appColor)),
                    child: Text(
                      data!.description,
                      style: Styles.textBlack15BNormal,
                    ),
                  )
                : SizedBox.shrink(),
            //  Most newest Listings
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Text('Details', style: Styles.textBlack24B),
                    ),
                  ),
                ),
                IconButton(
                  // padding: const EdgeInsets.only(right: 25),
                  icon: Icon(
                    isShoww == true
                        ? Icons.expand_more
                        : Icons.expand_less_outlined,
                    size: 30,
                    color: Colors.orange,
                  ),
                  highlightColor: Colors.orangeAccent,
                  onPressed: () {
                    setState(() {
                      isShoww = !isShoww;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            isShoww == true
                ? Container(
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
                                "Total Km's :",
                                style: Styles.textBlack15BNormal,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Total Owners :",
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
                                "Vehicle's name :",
                                style: Styles.textBlack15BNormal,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Bought For :",
                                style: Styles.textBlack15BNormal,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Bought On :",
                                style: Styles.textBlack15BNormal,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Total Km's :",
                                style: Styles.textBlack15BNormal,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Defects :",
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
                              data!.mileage,
                              // "Total Km's :",
                              style: Styles.textBlack15BNormal,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              // "Total Owners :",
                              data!.numberOfOwners,
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
                              data!.name,
                              style: Styles.textBlack15BNormal,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              // "Bought For :",
                              data!.originalPrice,
                              style: Styles.textBlack15BNormal,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              // "Bought On :",
                              data!.makeYear,
                              style: Styles.textBlack15BNormal,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              // "Total Km's :",
                              data!.mileage,
                              style: Styles.textBlack15BNormal,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              data!.defects.join(','),
                              // "Defects :",
                              style: Styles.textBlack15BNormal,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ))
                      ],
                    ),
                  )
                : SizedBox.shrink(),

            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Text('Listed By', style: Styles.textBlack24B),
                    ),
                  ),
                ),
                IconButton(
                  // padding: const EdgeInsets.only(right: 25),
                  icon: Icon(
                    isShowww == true
                        ? Icons.expand_more
                        : Icons.expand_less_outlined,
                    size: 30,
                    color: Colors.orange,
                  ),
                  highlightColor: Colors.orangeAccent,
                  onPressed: () {
                    setState(() {
                      isShowww = !isShowww;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            isShowww == true
                ? Container(
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
                              CircleAvatar(
                                  radius: getSize(50),
                                  backgroundImage: imageUrl != null
                                      ? NetworkImage(imageUrl!)
                                      : null,
                                  child: imageUrl == null
                                      ? CircleAvatar(
                                          radius: getSize(60),
                                          backgroundImage: const AssetImage(
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name ${name}",
                              // "Total Km's :",
                              style: Styles.textBlack15BNormal,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Name ${phone}",
                              // "Total Km's :",
                              style: Styles.textBlack15BNormal,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ))
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: isAdmin == 'true' ? false : true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isSent == false
                      ? ElevatedButton(
                          onPressed: () async {
                            if (data == null || data!.id == null) {
                              ToastMessage.showMessage('Data is Null');
                            } else {
                              try {
                                await FirebaseService
                                        .sendPurchaseRequestToListing(
                                            data!.id!, currentUser)
                                    .then((value) => {
                                          setState(() {
                                            setmyDatanew();
                                          })
                                        });
                                print("Purchase request sent successfully!");
                                ToastMessage.showMessage('Request Sent');
                              } catch (e) {
                                ToastMessage.showMessage('Error Occured : $e');

                                print("Failed to send purchase request: $e");
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.primaryColour,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(getSize(15)))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.send,
                                  color: CustomColors.secondaryColor,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text('Send Purchase Request',
                                    style: Styles.textWhite20),
                              ],
                            ),
                          ))
                      : ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.primaryColour,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(getSize(15)))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.send,
                                  color: CustomColors.secondaryColor,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text('Request Already Sent',
                                    style: Styles.textWhite20),
                              ],
                            ),
                          )),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ]),
        ));
  }
}
