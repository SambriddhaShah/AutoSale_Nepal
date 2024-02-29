import 'dart:async';

import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Firebase/ListingsModel.dart';
import 'package:auto_sale_nepal/Firebase/approvedListingsModel.dart';
import 'package:auto_sale_nepal/Firebase/service.dart';
import 'package:auto_sale_nepal/Screens/Screen/ApprovedListingsForBuyer/ApprovedListingsDetailsForBuyer.dart';
import 'package:auto_sale_nepal/Screens/Screen/product/productDetailda.dart';
import 'package:auto_sale_nepal/Utils/size_utils.dart';
import 'package:auto_sale_nepal/Utils/styles.dart';
import 'package:auto_sale_nepal/Utils/toast_message.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class UserListingsforAdmin extends StatefulWidget {
  String id;
  UserListingsforAdmin({super.key, required this.id});

  @override
  State<UserListingsforAdmin> createState() => _UserListingsforAdminState();
}

class _UserListingsforAdminState extends State<UserListingsforAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoadingapproved = true;
  List<ApprovedListing> _listingsAddedapproved = [];
  StreamSubscription<List<Listing>>? _listingsaddedSubscription;
  StreamSubscription<List<ApprovedListing>>?
      _listingsapprovedinterestedSubscription;

  bool _isLoadingAdded = true;
  List<Listing> _listingsAdded = [];
  bool show = true;
  bool showw = true;
  String id = '';

  @override
  void initState() {
    id = widget.id;
    setmyDataapproved();
    super.initState();
  }

  void setmyDataapproved() async {
    // Assuming this is in the main method or initState() of a StatefulWidget
    _listingsapprovedinterestedSubscription =
        FirebaseService.getApprovedListingsForBuyerAdmin(id).listen(
      (listings) {
        // Update the variable with the latest data
        setState(() {
          _listingsAddedapproved = listings;
          _isLoadingapproved = false;
          print('the listing is $_listingsAddedapproved');
          _listingsapprovedinterestedSubscription?.cancel();
          setmyDataAdded();
        });
      },
      onError: (error) {
        // Handle any errors
        print('Error fetching listings: $error');
        ToastMessage.showMessage('error occured fetching data $error');
      },
      onDone: () {
        setState(() {
          _isLoadingapproved = false;
        });
      },
    );
  }

  void setmyDataAdded() {
    // Assuming this is in the main method or initState() of a StatefulWidget
    _listingsaddedSubscription =
        FirebaseService.getListingsForUserAdmin(id).listen(
      (listings) {
        // Update the variable with the latest data
        setState(() {
          _listingsAdded = listings;
          _isLoadingAdded = false;
          print('the interested listing is $_listingsAdded');
          _listingsaddedSubscription?.cancel();
        });
        print('the interested data is $_listingsAdded');
      },
      onError: (error) {
        // Handle any errors
        print('Error fetching listings: $error');
        ToastMessage.showMessage('error occured fetching data $error');
      },
      onDone: () {
        setState(() {
          _isLoadingAdded = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _listingsaddedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
                      child: Text("Approved Listed Items",
                          style: Styles.textBlack20B),
                    ),
                  ),
                ),
                IconButton(
                  // padding: const EdgeInsets.only(right: 25),
                  icon: Icon(
                    show == true
                        ? Icons.expand_more
                        : Icons.expand_less_outlined,
                    size: 30,
                    color: Colors.orange,
                  ),
                  highlightColor: Colors.orangeAccent,
                  onPressed: () {
                    setState(() {
                      show = !show;
                    });
                  },
                ),
              ],
            ),
            show == true
                ? SingleChildScrollView(
                    child: Column(children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      height: MediaQuery.of(context).size.height * .23,
                      child: _isLoadingapproved == true
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
                          : _listingsAddedapproved.isEmpty
                              ? Container(
                                  // height: MediaQuery.of(context).size.height,
                                  // width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                      itemCount: _listingsAddedapproved.length,
                                      itemBuilder: (BuildContext context,
                                          int childIndex) {
                                        return Container(
                                          //  color: ,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .43,
                                          child: Card(
                                              elevation: 5,
                                              margin: const EdgeInsets.fromLTRB(
                                                  7, 7, 7, 7), // add margin

                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                      begin: Alignment.topRight,
                                                      end: Alignment(0, 0.1),
                                                      tileMode: TileMode.decal,
                                                      colors: [
                                                        CustomColors
                                                            .secondaryColor,
                                                        Color.fromRGBO(
                                                            251, 242, 253, 0.87)
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 10, 10, 0),
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 5,
                                                                    right: 5),
                                                            child:
                                                                // Image.network
                                                                Image.network(
                                                              _listingsAddedapproved[
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
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  .09,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.33,
                                                              // height: 75,
                                                              // width: 144,

                                                              fit: BoxFit.fill,
                                                              cacheHeight: 2000,
                                                              cacheWidth: 2000,
                                                              filterQuality:
                                                                  FilterQuality
                                                                      .medium,
                                                              scale: 50,
                                                              errorBuilder:
                                                                  (context, url,
                                                                          error) =>
                                                                      Image
                                                                          .asset(
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
                                                                fit:
                                                                    BoxFit.fill,
                                                                cacheHeight:
                                                                    2000,
                                                                cacheWidth:
                                                                    2000,
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .medium,
                                                                scale: 50,
                                                              ),
                                                            ),
                                                          )),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 10.0,
                                                          ),
                                                          child: Text(
                                                              _listingsAddedapproved[
                                                                      childIndex]
                                                                  .name,
                                                              maxLines: 2,
                                                              style: Styles
                                                                  .textBlack18,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis)),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .43,
                                                        height:
                                                            getVerticalSize(20),
                                                        child: Text(
                                                          _listingsAddedapproved[
                                                                  childIndex]
                                                              .description,
                                                          maxLines: 2,
                                                          style: Styles
                                                              .textBlack12,
                                                          // overflow: TextOverflow.ellipsis
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                          "Rs.${_listingsAddedapproved[childIndex].price}",
                                                          style: Styles
                                                              .textBlack14B,
                                                          overflow: TextOverflow
                                                              .ellipsis),
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
                                                          ApprovedListingsDetailsForBuyer(
                                                              data: _listingsAddedapproved[
                                                                  childIndex]),
                                                    ));
                                                  },
                                                ),
                                              )),
                                        );
                                      }),
                                ),
                    )
                  ]))
                : SizedBox.shrink(),

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
                      child: Text("Listed Items", style: Styles.textBlack20B),
                    ),
                  ),
                ),
                IconButton(
                  // padding: const EdgeInsets.only(right: 25),
                  icon: Icon(
                    showw == true
                        ? Icons.expand_more
                        : Icons.expand_less_outlined,
                    size: 30,
                    color: Colors.orange,
                  ),
                  highlightColor: Colors.orangeAccent,
                  onPressed: () {
                    setState(() {
                      showw = !showw;
                    });
                  },
                ),
              ],
            ),
            showw == false
                ? SizedBox.shrink()
                : _listingsAdded.isEmpty
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
                          Expanded(
                              child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns
                              crossAxisSpacing: 10.0, // Spacing between columns
                              mainAxisSpacing: 10.0, // Spacing between rows
                            ),
                            padding:
                                EdgeInsets.all(10.0), // Padding around the grid
                            itemCount: _listingsAdded.length,
                            itemBuilder: (context, index) {
                              return Container(
                                //  color: ,
                                width: MediaQuery.of(context).size.width * .43,

                                child: Stack(
                                  children: [
                                    Card(
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
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              right: 5),
                                                      child:
                                                          // Image.network
                                                          Image.network(
                                                        _listingsAdded[index]
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
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .09,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.33,
                                                        // height: 75,
                                                        // width: 144,

                                                        fit: BoxFit.fill,
                                                        cacheHeight: 2000,
                                                        cacheWidth: 2000,
                                                        filterQuality:
                                                            FilterQuality
                                                                .medium,
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
                                                        _listingsAdded[index]
                                                            .name,
                                                        maxLines: 2,
                                                        style:
                                                            Styles.textBlack18,
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
                                                    _listingsAdded[index]
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
                                                    "Rs.${_listingsAdded[index].price}",
                                                    style: Styles.textBlack14B,
                                                    overflow:
                                                        TextOverflow.ellipsis),
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
                                                        data: _listingsAdded[
                                                            index]),
                                              ));
                                            },
                                          ),
                                        )),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: CustomColors.appColor,
                                        ),
                                        onPressed: () {
                                          showDialogue(
                                              context,
                                              _listingsAdded[index].name!,
                                              _listingsAdded[index].id!,
                                              _listingsAdded[index].userId);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ))
                        ],
                      ))
          ]),
        ),
      ),
    );
  }

  void showDialogue(
      BuildContext context1, String name, String listingsid, String userid) {
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
                          onPressed: () {
                            FirebaseService.deleteListing(listingsid, userid)
                                .then((value) => {
                                      setmyDataapproved(),
                                      ToastMessage.showMessage(
                                          'Listing deleted')
                                    })
                                .catchError((error) {
                              ToastMessage.showMessage('Error: $error');
                            });
                            this.setState(() {});
                            Navigator.pop(dialogContext);
                          },
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
