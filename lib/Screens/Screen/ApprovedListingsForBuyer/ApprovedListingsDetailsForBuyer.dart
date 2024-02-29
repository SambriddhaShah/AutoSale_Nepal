import 'dart:async';
import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Firebase/service.dart';
import 'package:auto_sale_nepal/Screens/Screen/Payment/Payment.dart';
import 'package:auto_sale_nepal/Utils/size_utils.dart';
import 'package:auto_sale_nepal/Utils/styles.dart';
import 'package:auto_sale_nepal/Utils/toast_message.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Firebase/approvedListingsModel.dart';

class ApprovedListingsDetailsForBuyer extends StatefulWidget {
  ApprovedListing data;
  ApprovedListingsDetailsForBuyer({super.key, required this.data});

  @override
  State<ApprovedListingsDetailsForBuyer> createState() =>
      _ApprovedListingsDetailsForBuyerState();
}

class _ApprovedListingsDetailsForBuyerState
    extends State<ApprovedListingsDetailsForBuyer> {
  final controller = CarouselController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _imageUrls = [
    // Add more image URLs as needed
  ];
  ApprovedListing? data;
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
  StreamSubscription<ApprovedListing?>? _ApprovedListingsSubscription;

  @override
  TextEditingController searchProduct = TextEditingController();
  void initState() {
    data = widget.data;
    _imageUrls = data!.imageLinks;
    getAdmin();
    setIsSent();
    getUserData(data!.userId);
    setmyDatanew();
    print(
        'the truth value is ${(data!.isPaid == "true" || data!.isCOD == "true")}, the isPaid is ${data!.isPaid} and the isCOD value is ${data!.isCOD}');
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

  void launchGoogleMaps(String searchText) async {
    // Encode the search text to be URL safe
    String encodedSearchText = Uri.encodeFull(searchText);

    // Construct the URL with the search query
    String url =
        // 'https://www.google.com/maps/place/Budhanilkantha/@27.7678742,85.2786265,12z/data=!3m1!4b1!4m6!3m5!1s0x39eb1c257b30a06f:0x9819a88de0ee753!8m2!3d27.7654382!4d85.3652959!16s%2Fm%2F04jm894?entry=ttu';
        'https://www.google.com/maps/search/?api=1&query=$encodedSearchText';

    // Check if the URL can be launched
    if (await canLaunch(url)) {
      // Launch the URL
      await launch(url);
    } else {
      // Handle error, e.g., by showing an error dialog
      throw 'Could not launch $url';
    }
  }

  void setmyDatanew() {
    // Assuming this is in the main method or initState() of a StatefulWidget
    _ApprovedListingsSubscription =
        FirebaseService.getApprovedListingById(data!.id!).listen(
      (ApprovedListings) {
        // Update the variable with the latest data
        var lsit = ApprovedListings;
        setState(() {
          data = lsit;
          print('the new data is $lsit');
          _ApprovedListingsSubscription?.cancel();
          setIsSent();
        });
      },
      onError: (error) {
        // Handle any errors
        print('Error fetching ApprovedListings: $error');
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

            //  Most Popular ApprovedListings
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
            const SizedBox(
              height: 30,
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
                      child: Text("Rs. ${data!.price}",
                          style: Styles.textOrange24B),
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
            // const SizedBox(
            //   height: 30,
            // ),
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
                      child: Row(
                        children: [
                          Text("Status: ", style: Styles.textOrange24B),
                          Text(
                            data!.isCompleted == 'false'
                                ? ((data!.isCOD == 'true' ||
                                        data!.isPaid == 'true')
                                    ? data!.isCOD == 'true'
                                        ? "Cash On Delivery"
                                        : data!.isPaid == 'true'
                                            ? "Paid Via Khalti"
                                            : ""
                                    : "Payment Pending")
                                : "Completed",
                            style: Styles.textBlack24,
                          ),
                        ],
                      ),
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

            //  Most newest ApprovedListings
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
            //  Most newest ApprovedListings
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
                      child: Text('Seller', style: Styles.textBlack24B),
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
                    child: Column(
                      children: [
                        Row(
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
                                  "Name: ${name}",
                                  // "Total Km's :",
                                  style: Styles.textBlack15BNormal,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Phone: ${phone}",
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
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  final Uri url =
                                      Uri(scheme: 'tel', path: phone);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    ToastMessage.showMessage(
                                        "Couldn't call Seller");
                                  }

                                  // callNumber(phone!);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: CustomColors.primaryColour,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            getSize(15)))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: CustomColors.secondaryColor,
                                        size: 15,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('Call Seller',
                                          style: Styles.textWhite14),
                                    ],
                                  ),
                                ))
                          ],
                        )
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
                  (data!.isPaid == 'true' || data!.isCOD == 'true') == true
                      ? ElevatedButton(
                          onPressed: () {
                            launchGoogleMaps(data!.location);
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
                                  Icons.payment_outlined,
                                  color: CustomColors.secondaryColor,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text('See Location', style: Styles.textWhite20),
                              ],
                            ),
                          ))
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                  builder: (context) => PaymentPage(
                                    data: [
                                      data,
                                      name,
                                      phone,
                                      data!.purchaserequests
                                    ],
                                  ),
                                ))
                                .then((value) => {setmyDatanew()});
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
                                  Icons.payment_outlined,
                                  color: CustomColors.secondaryColor,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text('Pay Now', style: Styles.textWhite20),
                              ],
                            ),
                          )),
                  // : SizedBox.shrink(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
