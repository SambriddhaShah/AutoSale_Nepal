import 'dart:async';

import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Firebase/ListingsModel.dart';
import 'package:auto_sale_nepal/Firebase/service.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/Drawer/drawerPage.dart';
import 'package:auto_sale_nepal/Screens/Screen/userListings/AddListing.dart';
import 'package:auto_sale_nepal/Screens/Screen/userListings/editListing.dart';
import 'package:auto_sale_nepal/Utils/size_utils.dart';
import 'package:auto_sale_nepal/Utils/styles.dart';
import 'package:auto_sale_nepal/Utils/toast_message.dart';
import 'package:flutter/material.dart';

class UserListingsPage extends StatefulWidget {
  const UserListingsPage({super.key});

  @override
  State<UserListingsPage> createState() => _UserListingsPageState();
}

class _UserListingsPageState extends State<UserListingsPage> {
  List data = [1];
  StreamSubscription<List<Listing>>? _listingsSubscription;
  List<Listing> _listings = [];
  bool _isLoading = true;

  void setmyData() {
    // Assuming this is in the main method or initState() of a StatefulWidget
    _listingsSubscription = FirebaseService.getListingsForUser().listen(
      (listings) {
        // Update the variable with the latest data
        setState(() {
          _listings = listings;
          _isLoading = false;
          print('the listing is $_listings');
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
          _isLoading = false;
        });
      },
    );
  }

  @override
  void initState() {
    setmyData();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                              builder: (context) => AddListingsPage(),
                            ))
                            .then((value) => {setmyData()});
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
                              Icons.add_box_outlined,
                              color: CustomColors.secondaryColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text('Add Listing', style: Styles.textWhite14),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
                Divider(
                  color: CustomColors.appColor,
                  height: getSize(2),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("My Listings", style: Styles.textBlack24B)],
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
                                  child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // Number of columns
                                    crossAxisSpacing:
                                        10.0, // Spacing between columns
                                    mainAxisSpacing:
                                        10.0, // Spacing between rows
                                  ),
                                  padding: EdgeInsets.all(
                                      10.0), // Padding around the grid
                                  itemCount: _listings.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      //  color: ,
                                      width: MediaQuery.of(context).size.width *
                                          .43,

                                      child: Stack(
                                        children: [
                                          Card(
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
                                                              _listings[index]
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
                                                              _listings[index]
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
                                                          _listings[index]
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
                                                          "Rs.${_listings[index].price}",
                                                          style: Styles
                                                              .textBlack14B,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditListingPage(
                                                              id: _listings[
                                                                      index]
                                                                  .id!),
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
                                                    _listings[index].name!,
                                                    _listings[index].id!,
                                                    _listings[index].userId);
                                              },
                                            ),
                                          )
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

  void showDialogue(
      BuildContext context1, String name, String listingid, String userid) {
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
                            FirebaseService.deleteListing(listingid, userid)
                                .then((value) => {
                                      setmyData(),
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
