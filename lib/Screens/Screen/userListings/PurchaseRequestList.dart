import 'dart:async';

import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Firebase/ListingsModel.dart';
import 'package:auto_sale_nepal/Firebase/approvedListingsModel.dart';
import 'package:auto_sale_nepal/Firebase/service.dart';
import 'package:auto_sale_nepal/Screens/Screen/ApprovedListingsforSeller/ApprovedListingsPage.dart';
import 'package:auto_sale_nepal/Utils/size_utils.dart';
import 'package:auto_sale_nepal/Utils/styles.dart';
import 'package:auto_sale_nepal/Utils/toast_message.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PurchaseRequestListPage extends StatefulWidget {
  Listing data;
  PurchaseRequestListPage({super.key, required this.data});

  @override
  State<PurchaseRequestListPage> createState() =>
      _PurchaseRequestListPageState();
}

class _PurchaseRequestListPageState extends State<PurchaseRequestListPage> {
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

  String? name;
  String? phone;
  String? imageUrl;
  String currentUser = FirebaseAuth.instance.currentUser!.uid.toString();
  bool isSent = false;
  StreamSubscription<Listing?>? _listingsSubscription;
  Map<String, dynamic> userData = {};

  @override
  TextEditingController searchProduct = TextEditingController();
  void initState() {
    data = widget.data;
    _imageUrls = data!.imageLinks;
    getUserData(data!.purchaserequests);
    setIsSent();
    // getUserData(data!.userId);
    super.initState();
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
  void getUserData(List<String> userUids) async {
    try {
      var Data = await FirebaseService.getUserDataForPurchaseRequests(userUids);
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
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                              height: MediaQuery.of(context).size.height * 0.38,
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
                          aspectRatio:
                              getHorizontalSize(350), // Adjust the aspect ratio
                          viewportFraction: 1.0, //
                          // autoPlay: true,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration: const Duration(seconds: 2),
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
                    child:
                        Text('Purchase Requests', style: Styles.textBlack24B),
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
              ? userData.isEmpty
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
                  : Container(
                      height: MediaQuery.of(context).size.height / 2.7,
                      // color: Colors.blue,
                      child: ListView.builder(
                        itemCount: userData!.length,
                        itemBuilder: (context, index) {
                          // Get the user data for the current index
                          Map<String, dynamic> user =
                              userData!.values.elementAt(index);
                          String key = userData.keys.elementAt(index);

                          return Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.5),
                                border:
                                    Border.all(color: CustomColors.appColor)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                              radius: getSize(50),
                                              backgroundImage:
                                                  user['imageLink'] != null
                                                      ? NetworkImage(
                                                          user['imageLink'])
                                                      : null,
                                              child: user['imageLink'] == null
                                                  ? CircleAvatar(
                                                      radius: getSize(60),
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
                                          style: Styles.textBlack15BNormal,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Name ${user['Phone']}",
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
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () async {
                                            if (data == null ||
                                                data!.id == null) {
                                              ToastMessage.showMessage(
                                                  'Data is Null');
                                            } else {
                                              try {
                                                await FirebaseService.approvePurchaseRequest(
                                                        data!.id!,
                                                        ApprovedListing(
                                                            id: data!.id!,
                                                            userId:
                                                                data!.userId,
                                                            name: data!.name,
                                                            brand: data!.brand,
                                                            makeYear:
                                                                data!.makeYear,
                                                            mileage:
                                                                data!.mileage,
                                                            numberOfOwners: data!
                                                                .numberOfOwners,
                                                            price: data!.price,
                                                            description: data!
                                                                .description,
                                                            defects:
                                                                data!.defects,
                                                            imageLinks: data!
                                                                .imageLinks,
                                                            purchaserequests:
                                                                key,
                                                            datetime:
                                                                data!.datetime,
                                                            originalPrice: data!
                                                                .originalPrice,
                                                            isCOD: 'false',
                                                            isPaid: 'false',
                                                            isCompleted:
                                                                'false',
                                                            location:
                                                                data!.location))
                                                    .then((value) => {
                                                          Navigator.of(context)
                                                              .pop(),
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                ApprovedListingsPage(),
                                                          )),
                                                        });
                                                print(
                                                    "Purchase request accepted successfully!");
                                                ToastMessage.showMessage(
                                                    'Request Approved');
                                              } catch (e) {
                                                ToastMessage.showMessage(
                                                    'Error Occured : $e');

                                                print(
                                                    "Failed to send purchase request: $e");
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  CustomColors.primaryColour,
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          getSize(15)))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.approval_outlined,
                                                  color: CustomColors
                                                      .secondaryColor,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text('Approve',
                                                    style: Styles.textWhite20),
                                              ],
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
              : SizedBox.shrink(),
        ]));
  }
}
