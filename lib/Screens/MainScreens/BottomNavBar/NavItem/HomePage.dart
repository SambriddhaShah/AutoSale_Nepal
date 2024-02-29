import 'dart:async';

import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Firebase/ListingsModel.dart';
import 'package:auto_sale_nepal/Firebase/service.dart';
import 'package:auto_sale_nepal/Screens/Screen/product/productDetailda.dart';
import 'package:auto_sale_nepal/Utils/size_utils.dart';
import 'package:auto_sale_nepal/Utils/styles.dart';
import 'package:auto_sale_nepal/Utils/toast_message.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final void Function(int, String) navigateToTab;
  const HomePage({super.key, required this.navigateToTab});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = CarouselController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _imageUrls = [
    "https://via.placeholder.com/300",
    "https://via.placeholder.com/300",
    "https://via.placeholder.com/300",
    // Add more image URLs as needed
  ];
  int currentIndex = 0;
  bool _isLoadingmostpopular = true;
  List<Listing> _listingspopular = [];
  StreamSubscription<List<Listing>>? _listingsSubscription;

  bool _isLoadingnew = true;
  List<Listing> _listingsnew = [];

  @override
  TextEditingController searchProduct = TextEditingController();
  void initState() {
    setmyData();
    setmyDatanew();
    super.initState();
  }

  void setmyData() async {
    try {
      List<Listing> listings =
          await FirebaseService.getListingsWithMorePurchaseRequests();
      setState(() {
        _listingspopular = listings;
        _isLoadingmostpopular = false;
      });
    } catch (error) {
      // Handle any errors
      print('Error fetching listings: $error');
      ToastMessage.showMessage('error occured fetching data $error');
      setState(() {
        _isLoadingmostpopular = false;
      });
    }
  }

  void setmyDatanew() {
    // Assuming this is in the main method or initState() of a StatefulWidget
    _listingsSubscription = FirebaseService.getListingssortedtime().listen(
      (listings) {
        // Update the variable with the latest data
        var lsit = listings.where((element) =>
            element.userId != FirebaseAuth.instance.currentUser!.uid);
        setState(() {
          // _listingsnew =
          _listingsnew.addAll(listings.where((element) =>
              element.userId != FirebaseAuth.instance.currentUser!.uid));
          _isLoadingnew = false;
          print('the listing is $_listingsnew');
          _listingsSubscription?.cancel();
        });
      },
      onError: (error) {
        // Handle any errors
        print('Error fetching listings: $error');
        ToastMessage.showMessage('error occured fetching data $error');
      },
      onDone: () {
        setState(() {
          _isLoadingnew = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _listingsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.menu,
        //     size: getSize(30),
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     _scaffoldKey.currentState?.openDrawer();
        //   },
        // ),
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
          Container(
            color: CustomColors.appColor,
            height: getVerticalSize(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: getVerticalSize(20),
                  decoration: BoxDecoration(
                    color: CustomColors.secondaryColor,
                    border: null,
                    boxShadow: null,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(33)),
              elevation: 2,
              child: TextField(
                controller: searchProduct,
                autofocus: false,
                keyboardAppearance: null,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 5, left: 15),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      if (searchProduct.text.isNotEmpty) {
                        print('the starting search is ${searchProduct.text}');
                        widget.navigateToTab(1, searchProduct.text);
                        // SearchProductDTO();
                        // Navigator.of(context).pushNamed('/searchproduct',
                        //     arguments: SearchProductDTO(
                        //         keyword: searchProduct.text,
                        //         categoryId: 0));
                        // searchProduct.clear();
                        //print('sesarch');
                      } else {
                        // print('Empty Field');
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //   content: Text("Sending Message"),
                        // ));
                        ToastMessage.showMessage("Empty Field");
                      }
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  hoverColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(color: Colors.white, width: 0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "What are you looking for ?",
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          CarouselSlider.builder(
              carouselController: controller,
              itemCount: _listingsnew.length >= 3 ? 3 : _listingsnew.length,
              itemBuilder: (context, index, realIndex) {
                return Stack(children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.38,
                      margin: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: CustomColors.appColor),
                        // color: CustomColors.appColor,r
                        image: DecorationImage(
                          image:
                              NetworkImage(_listingsnew[index].imageLinks[0]),
                          fit:
                              BoxFit.cover, // Adjust the fit property as needed
                        ),
                      ),
                      // child: ,
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(getHorizontalSize(20),
                  //       getVerticalSize(40), getHorizontalSize(20), 0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () {
                  //           Navigator.of(context).push(MaterialPageRoute(
                  //               builder: (context) => ProfilePage()));
                  //         },
                  //         child: Material(
                  //           elevation: 5,
                  //           borderRadius: BorderRadius.circular(100),
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Container(
                  //               height: getVerticalSize(25),
                  //               width: getHorizontalSize(25),
                  //               decoration: const BoxDecoration(
                  //                   color: Colors.white,
                  //                   shape: BoxShape.circle),
                  //               child: Center(
                  //                 child: Icon(
                  //                   Icons.person,
                  //                   color: CustomColors.appColor,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   alignment: Alignment.center,
                  //   child: Text(
                  //     'Name',
                  //     style: Styles.textWhite20,
                  //   ),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(
                  //       getHorizontalSize(20), 0, 0, getVerticalSize(30)),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       ElevatedButton(
                  //         onPressed: () {},
                  //         style: ElevatedButton.styleFrom(
                  //             backgroundColor: CustomColors.appColor,
                  //             padding: EdgeInsets.zero,
                  //             fixedSize: Size(
                  //                 getHorizontalSize(100), getVerticalSize(40))),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Icon(
                  //               Icons.bookmark_add,
                  //               color: Colors.white,
                  //               size: getSize(20),
                  //             ),
                  //             Text(
                  //               'Save Now',
                  //               style: Styles.textWhite20,
                  //             )
                  //           ],
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // )
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
          SizedBox(
            height: 10,
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
                    child: Text("Most Popular Listings",
                        style: Styles.textBlack20B),
                  ),
                ),
              ),
              IconButton(
                // padding: const EdgeInsets.only(right: 25),
                icon: const Icon(
                  Icons.expand_more,
                  size: 30,
                  color: Colors.orange,
                ),
                highlightColor: Colors.orangeAccent,
                onPressed: () {
                  Navigator.of(context).pushNamed('/moremostpopular');
                },
              ),
            ],
          ),
          SingleChildScrollView(
              child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20),
              height: MediaQuery.of(context).size.height * .23,
              child: _isLoadingmostpopular == true
                  ? Container(
                      // height: MediaQuery.of(context).size.height,
                      // width: MediaQuery.of(context).size.width,
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
                  : _listingspopular.isEmpty
                      ? Container(
                          // height: MediaQuery.of(context).size.height,
                          // width: MediaQuery.of(context).size.width,
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
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          //color: Colors.purple,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              // shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemCount: _listingspopular.length,
                              itemBuilder:
                                  (BuildContext context, int childIndex) {
                                return Container(
                                  //  color: ,
                                  width:
                                      MediaQuery.of(context).size.width * .43,
                                  child: Card(
                                      elevation: 5,
                                      margin: const EdgeInsets.fromLTRB(
                                          7, 7, 7, 7), // add margin

                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment(0, 0.1),
                                              tileMode: TileMode.decal,
                                              colors: [
                                                CustomColors.secondaryColor,
                                                Color.fromRGBO(
                                                    251, 242, 253, 0.87)
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 10, 10, 0),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child:
                                                        // Image.network
                                                        Image.network(
                                                      _listingspopular[
                                                              childIndex]
                                                          .imageLinks[0],
                                                      // ApiUrl.imageBaseUrl +
                                                      //     HtmlUnescape()
                                                      //         .convert(mostPopular[
                                                      //                 index]
                                                      //             .categoryProducts![
                                                      //                 childIndex]
                                                      //             .imgUrl
                                                      //             .toString())
                                                      //         .trim(),
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .09,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.33,
                                                      // height: 75,
                                                      // width: 144,

                                                      fit: BoxFit.fill,
                                                      cacheHeight: 2000,
                                                      cacheWidth: 2000,
                                                      filterQuality:
                                                          FilterQuality.medium,
                                                      scale: 50,
                                                      errorBuilder: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                        "assets/images/default.png",
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .09,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .33,
                                                        fit: BoxFit.fill,
                                                        cacheHeight: 2000,
                                                        cacheWidth: 2000,
                                                        filterQuality:
                                                            FilterQuality
                                                                .medium,
                                                        scale: 50,
                                                      ),
                                                    ),
                                                  )),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 10.0,
                                                  ),
                                                  child: Text(
                                                      _listingspopular[
                                                              childIndex]
                                                          .name,
                                                      maxLines: 2,
                                                      style: Styles.textBlack18,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .43,
                                                height: getVerticalSize(20),
                                                child: Text(
                                                  _listingspopular[childIndex]
                                                      .description,
                                                  maxLines: 2,
                                                  style: Styles.textBlack12,
                                                  // overflow: TextOverflow.ellipsis
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                  "Rs.${_listingspopular[childIndex].price}",
                                                  style: Styles.textBlack14B,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailsView(
                                                      data: _listingspopular[
                                                          childIndex]),
                                            ));
                                          },
                                        ),
                                      )),
                                );
                              }),
                        ),
            )
          ])),

          //  Most newest Listings
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
                    child: Text("New Arrivals", style: Styles.textBlack20B),
                  ),
                ),
              ),
              IconButton(
                // padding: const EdgeInsets.only(right: 25),
                icon: const Icon(
                  Icons.expand_more,
                  size: 30,
                  color: Colors.orange,
                ),
                highlightColor: Colors.orangeAccent,
                onPressed: () {
                  Navigator.of(context).pushNamed('/moremostpopular');
                },
              ),
            ],
          ),
          SingleChildScrollView(
              child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: 20,
              ),
              height: MediaQuery.of(context).size.height * .23,
              child: _listingsnew.isEmpty
                  ? Container(
                      // height: MediaQuery.of(context).size.height,
                      // width: MediaQuery.of(context).size.width,
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
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      //color: Colors.purple,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          // shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              _listingsnew.length > 5 ? 5 : _listingsnew.length,
                          itemBuilder: (BuildContext context, int childIndex) {
                            return Container(
                              //  color: ,
                              width: MediaQuery.of(context).size.width * .43,
                              child: Card(
                                  elevation: 5,
                                  margin: const EdgeInsets.fromLTRB(
                                      7, 7, 7, 7), // add margin

                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment(0, 0.1),
                                          tileMode: TileMode.decal,
                                          colors: [
                                            CustomColors.secondaryColor,
                                            Color.fromRGBO(251, 242, 253, 0.87)
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 0),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child:
                                                    // Image.network
                                                    Image.network(
                                                  _listingsnew[childIndex]
                                                      .imageLinks[0],
                                                  // ApiUrl.imageBaseUrl +
                                                  //     HtmlUnescape()
                                                  //         .convert(mostPopular[
                                                  //                 index]
                                                  //             .categoryProducts![
                                                  //                 childIndex]
                                                  //             .imgUrl
                                                  //             .toString())
                                                  //         .trim(),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .09,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.33,
                                                  // height: 75,
                                                  // width: 144,

                                                  fit: BoxFit.fill,
                                                  cacheHeight: 2000,
                                                  cacheWidth: 2000,
                                                  filterQuality:
                                                      FilterQuality.medium,
                                                  scale: 50,
                                                  errorBuilder:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    "assets/images/default.png",
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .09,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .33,
                                                    fit: BoxFit.fill,
                                                    cacheHeight: 2000,
                                                    cacheWidth: 2000,
                                                    filterQuality:
                                                        FilterQuality.medium,
                                                    scale: 50,
                                                  ),
                                                ),
                                              )),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                              ),
                                              child: Text(
                                                  _listingsnew[childIndex].name,
                                                  maxLines: 2,
                                                  style: Styles.textBlack18,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .43,
                                            height: getVerticalSize(20),
                                            child: Text(
                                              _listingsnew[childIndex]
                                                  .description,
                                              maxLines: 2,
                                              style: Styles.textBlack12,
                                              // overflow: TextOverflow.ellipsis
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                              "Rs.${_listingsnew[childIndex].price}",
                                              style: Styles.textBlack14B,
                                              overflow: TextOverflow.ellipsis),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        print('the gesture dector worked');
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailsView(
                                                  data:
                                                      _listingsnew[childIndex]),
                                        ));
                                      },
                                    ),
                                  )),
                            );
                          }),
                    ),
            )
          ])),
        ]),
      ),
    );
  }
}
