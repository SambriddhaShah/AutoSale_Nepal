import 'dart:async';
import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Firebase/ListingsModel.dart';
import 'package:auto_sale_nepal/Firebase/service.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/Drawer/drawerPage.dart';
import 'package:auto_sale_nepal/Screens/Screen/product/productDetailda.dart';
import 'package:auto_sale_nepal/Utils/size_utils.dart';
import 'package:auto_sale_nepal/Utils/styles.dart';
import 'package:auto_sale_nepal/Utils/toast_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyListingsPage extends StatefulWidget {
  String search;
  MyListingsPage({super.key, required this.search});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  TextEditingController searchProduct = TextEditingController();

  StreamSubscription<List<Listing>>? _listingsSubscription;
  List<Listing> _listings = [];
  bool _isLoading = true;

  void setmyData() {
    // Assuming this is in the main method or initState() of a StatefulWidget
    _listingsSubscription = FirebaseService.getListings().listen(
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

  void setmyDataSearch(String sear) {
    // Assuming this is in the main method or initState() of a StatefulWidget
    _listingsSubscription = FirebaseService.getListingsbySearch(sear).listen(
      (listings) {
        // Update the variable with the latest data
        setState(() {
          _listings.clear();
          _listings.addAll(listings.where((element) =>
              element.userId != FirebaseAuth.instance.currentUser!.uid));
          _isLoading = false;
          print('the search listing is $_listings');
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
  void dispose() {
    _listingsSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    print('the search is ${widget.search}');
    if (widget.search != '') {
      setmyDataSearch(widget.search);
      setState(() {
        searchProduct.text = widget.search;
      });
    } else {
      setmyData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // iconTheme: const IconThemeData(color: Colors.white),
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
              ////decoration: BoxDecoration(color: CustomColors.appColor),
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
                SizedBox(
                  height: 10,
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
                              setmyDataSearch(searchProduct.text);
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
                          borderSide:
                              const BorderSide(color: Colors.white, width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "What are you looking for ?",
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(20),
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
                          child: Text(
                              searchProduct.text != ''
                                  ? 'Search Results for: ${searchProduct.text}'
                                  : "All Listings",
                              style: Styles.textBlack20B),
                        ),
                      ),
                    ),
                    searchProduct.text != ''
                        ? IconButton(
                            // padding: const EdgeInsets.only(right: 25),
                            icon: const Icon(
                              Icons.dangerous_outlined,
                              size: 30,
                              color: Colors.red,
                            ),
                            highlightColor: Colors.orangeAccent,
                            onPressed: () {
                              setState(() {
                                searchProduct.clear();
                                setmyData();
                              });
                            },
                          )
                        : SizedBox.shrink(),
                  ],
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
                        child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing: 10.0, // Spacing between columns
                          mainAxisSpacing: 10.0, // Spacing between rows
                        ),
                        padding:
                            EdgeInsets.all(10.0), // Padding around the grid
                        itemCount: _listings.length,
                        itemBuilder: (context, index) {
                          return Container(
                            //  color: ,
                            width: MediaQuery.of(context).size.width * .43,
                            child: Card(
                                elevation: 5,
                                margin: const EdgeInsets.fromLTRB(
                                    7, 7, 7, 7), // add margin

                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
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
                                      borderRadius: BorderRadius.circular(15)),
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
                                                _listings[index].imageLinks[0],
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
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .09,
                                                  width: MediaQuery.of(context)
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
                                            child: Text(_listings[index].name,
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
                                            _listings[index].description,
                                            maxLines: 2,
                                            style: Styles.textBlack12,
                                            // overflow: TextOverflow.ellipsis
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text("Rs.${_listings[index].price}",
                                            style: Styles.textBlack14B,
                                            overflow: TextOverflow.ellipsis),
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
                                                data: _listings[index]),
                                      ));
                                    },
                                  ),
                                )),
                          );
                        },
                      ))
              ]),
            ),
    );
  }
}
