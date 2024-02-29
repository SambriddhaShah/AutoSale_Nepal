import 'dart:typed_data';
import 'package:auto_sale_nepal/Constants/constants.dart';
import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Firebase/ListingsModel.dart';
import 'package:auto_sale_nepal/Firebase/service.dart';
import 'package:auto_sale_nepal/Screens/components/location_list_tile.dart';
import 'package:auto_sale_nepal/Utils/networkUtils.dart';
import 'package:auto_sale_nepal/Utils/size_utils.dart';
import 'package:auto_sale_nepal/Utils/styles.dart';
import 'package:auto_sale_nepal/Utils/toast_message.dart';
import 'package:auto_sale_nepal/models/autocomplate_prediction.dart';
import 'package:auto_sale_nepal/models/place_auto_complate_response.dart';
import 'package:auto_sale_nepal/profileImage/saveImageListing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class AddListingsPage extends StatefulWidget {
  @override
  _AddListingsPageState createState() => _AddListingsPageState();
}

class _AddListingsPageState extends State<AddListingsPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedBrand;
  String? selectedNumberOfOwners;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController miellageController = TextEditingController();
  final TextEditingController originalpricecontroller = TextEditingController();
  TextEditingController location = TextEditingController();
  String currentUseruid = FirebaseAuth.instance.currentUser!.uid;

  Uint8List? _image;
  List<Uint8List> imageList = [];
  List<String> imageUrls = [];
  List<String> defects = [
    'Engine Problem',
    'Body Work Problem',
    'Paint Problem',
    'Rusting Issue',
    'Minor Asthetic Problems',
    'Maintainance Pendng'
  ];
  List<AutocompletePrediction> placePredictions = [];
  DateTime? selectedDate;
  var predValue = "";
  List<Object?> _selectedDefects = [];
  List<String> _selectedDefectString = [];
  var _items;
  List<dynamic>? _output;
  String? predictedData;
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      ToastMessage.showMessage('Location services are disabled');

      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        ToastMessage.showMessage('Location permissions are denied');

        return Future.error('Location permissions are denied');
      }
    } else if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      ToastMessage.showMessage(
          'Location permissions are permanently denied, we cannot request permissions');

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions');
    } else if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        setState(() {
          debugPrint(placemarks.toString());
          location.text = placemarks[0].name ?? "";
        });
      } catch (e) {
        print(e);
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void autoCompletePlaces(String placename) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "/maps/api/place/autocomplete/json",
        {'input': placename, 'key': CustomColors.apiKey});

    String? response = await NetworkUtiliti.fetchUrl(uri);

    if (response != null) {
      print(response);
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  Future<void> predData(int year, int owners, int actual, int km) async {
    final interpreter = await Interpreter.fromAsset('assets/finalone.tflite');
    var input = [
      [year, owners, actual, km, km]
      // [2007, 2, 1200000, 35000, 35000]
    ];
    var output = List.filled(1, 0).reshape([1, 1]);
    interpreter.run(input, output);
    print(output[0][0]);

    setState(() {
      predValue = output[0][0].toString();
      _price.text = predValue;
    });
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //       dateController.text = '${selectedDate!.toLocal()}'.split(' ')[0];
  //     });
  //   }
  // }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = '${selectedDate!.toLocal().year}';
      });
    }
  }

  void setData() {
    setState(() {
      _items = defects
          .map((animal) => MultiSelectItem<String>(animal, animal))
          .toList();
    });
  }

  Future<void> selectImage() async {
    final ImagePicker _imagePicker = ImagePicker();
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = await pickedFile.readAsBytes();

      setState(() {
        imageList.add(_image!);
      });
    }
  }

  Future<List<String>> saveImage(List<Uint8List> imag) async {
    for (Uint8List img in imag) {
      String resp = await StoreDataListing().saveData(file: img);
      imageUrls.add(resp);
    }

    return imageUrls;
  }

  // Future<void> selectImage(ImageSource source) async {
  //   final ImagePicker _imagePicker = ImagePicker();
  //   final pickedFile = await _imagePicker.pickImage(source: source);
  //   if (pickedFile != null) {
  //     return await pickedFile!.readAsBytes();
  //   } else {
  //     ToastMessage.showMessage("Could't select image");
  //   }
  //   print("No image Selected");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appColor,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Container(
                //   color: CustomColors.appColor,
                //   height: getVerticalSize(40),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: <Widget>[
                //       Container(
                //         height: getVerticalSize(20),
                //         decoration: BoxDecoration(
                //           color: CustomColors.secondaryColor,
                //           border: null,
                //           boxShadow: null,
                //           borderRadius: const BorderRadius.only(
                //             topLeft: Radius.circular(50.0),
                //             topRight: Radius.circular(50.0),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: CustomColors.secondaryColor),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Add Listing", style: Styles.textBlack24B)
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.5),
                            color: CustomColors.appColor),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Add Location',
                                  style: Styles.textBlack15B,
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                onChanged: (value) {
                                  autoCompletePlaces(value);
                                },
                                textInputAction: TextInputAction.search,
                                controller: location,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  // fillColor: Colors.white,
                                  hintText: "Search your location",
                                  hintStyle: Styles.textWhite20Normal,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: SvgPicture.asset(
                                      "assets/icons/location_pin.svg",
                                      color: secondaryColor40LightTheme,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color:
                                              CustomColors.inputTextBoarder)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: HexColor('#FF2800'),
                                          width: 2.0)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: HexColor('#FF2800'),
                                          width: getHorizontalSize(2))),
                                  // prefixIcon: const Icon(Icons.key,
                                  //     color: Colors.grey),
                                  // suffixIcon: GestureDetector(
                                  //   onTap: () {
                                  //     // ToastMessage.showMessage("Click");
                                  //     _togglevisibility();
                                  //   },
                                  //   child: Icon(
                                  //       _showPassword
                                  //           ? Icons.visibility
                                  //           : Icons.visibility_off,
                                  //       color: CustomColors.appColor),
                                  // ),
                                ),
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return 'Enter a location';
                                //   }
                                // }
                              ),
                            ),
                            const Divider(
                              height: 4,
                              thickness: 4,
                              color: CustomColors.appColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _determinePosition();
                                  // autoCompletePlaces('Dubai');
                                },
                                icon: SvgPicture.asset(
                                  "assets/icons/location.svg",
                                  height: 16,
                                ),
                                label: const Text("Use my Current Location"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: secondaryColor10LightTheme,
                                  foregroundColor: textColorLightTheme,
                                  elevation: 0,
                                  fixedSize: const Size(double.infinity, 40),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              height: 4,
                              thickness: 4,
                              color: CustomColors.appColor,
                            ),
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                              color: CustomColors.secondaryColor,
                              child: ListView.builder(
                                itemCount: placePredictions.length,
                                itemBuilder: (context, index) {
                                  return LocationListTile(
                                    press: () {
                                      setState(() {
                                        location.clear();
                                        location.text = placePredictions[index]
                                                .description ??
                                            "";
                                      });
                                    },
                                    location:
                                        placePredictions[index].description!,
                                  );
                                },
                              ),
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: getHorizontalSize(10),
                            vertical: getVerticalSize(5)),
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: getHorizontalSize(10),
                        //     vertical: getVerticalSize(9)),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(getSize(10)),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            value: selectedBrand,
                            hint: Text('Select Brand'),
                            onChanged: (value) {
                              setState(() {
                                selectedBrand = value;
                              });
                            },
                            items: <String>[
                              'Hyundai',
                              'Mahindra',
                              'Ford',
                              'Maruti',
                              'Skoda',
                              'Audi',
                              'Toyota',
                              'Renault',
                              'Honda',
                              'Datsun',
                              'Mitsubishi',
                              'Tata',
                              'Volkswagen',
                              'Chevrolet',
                              'Mini',
                              'BMW',
                              'Nissan',
                              'Hindustan',
                              'Fiat',
                              'Force',
                              'Mercedes',
                              'Land',
                              'Jaguar',
                              'Jeep',
                              'Volvo'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Select a value';
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: getHorizontalSize(10),
                            vertical: getVerticalSize(5)),
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: getHorizontalSize(10),
                        //     vertical: getVerticalSize(9)),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(getSize(10)),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Select a value';
                              }
                              return null;
                            },
                            value: selectedNumberOfOwners,
                            hint: Text('Select Number of Owners'),
                            onChanged: (value) {
                              setState(() {
                                selectedNumberOfOwners = value;
                              });
                            },
                            items: <String>['1', '2', '3', '4', '5+']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                            getHorizontalSize(20),
                            getVerticalSize(10),
                            getHorizontalSize(20),
                            getVerticalSize(10),
                          ),
                          hintText: "Enter vehicle name",
                          hintStyle: Styles.hintTextStyle15,
                          fillColor: HexColor('#F4F3F3'),
                          labelText: 'Vechile Name',
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: CustomColors.inputTextBoarder)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: HexColor('#FF2800'), width: 2.0)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: HexColor('#FF2800'),
                                  width: getHorizontalSize(2))),
                          // prefixIcon: const Icon(Icons.key,
                          //     color: Colors.grey),
                          // suffixIcon: GestureDetector(
                          //   onTap: () {
                          //     // ToastMessage.showMessage("Click");
                          //     _togglevisibility();
                          //   },
                          //   child: Icon(
                          //       _showPassword
                          //           ? Icons.visibility
                          //           : Icons.visibility_off,
                          //       color: CustomColors.appColor),
                          // ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the vehicle name';
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: originalpricecontroller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                            getHorizontalSize(20),
                            getVerticalSize(10),
                            getHorizontalSize(20),
                            getVerticalSize(10),
                          ),
                          hintText: "Enter original price",
                          hintStyle: Styles.hintTextStyle15,
                          fillColor: HexColor('#F4F3F3'),
                          labelText: 'original price',
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: CustomColors.inputTextBoarder)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: HexColor('#FF2800'), width: 2.0)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: HexColor('#FF2800'),
                                  width: getHorizontalSize(2))),
                          // prefixIcon: const Icon(Icons.key,
                          //     color: Colors.grey),
                          // suffixIcon: GestureDetector(
                          //   onTap: () {
                          //     // ToastMessage.showMessage("Click");
                          //     _togglevisibility();
                          //   },
                          //   child: Icon(
                          //       _showPassword
                          //           ? Icons.visibility
                          //           : Icons.visibility_off,
                          //       color: CustomColors.appColor),
                          // ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the original price';
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: Styles.textBlack16B,
                          ),
                        ],
                      ),
                      TextFormField(
                        maxLines: 5,
                        controller: description,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                            getHorizontalSize(20),
                            getVerticalSize(10),
                            getHorizontalSize(20),
                            getVerticalSize(10),
                          ),
                          hintText: "Enter Description",
                          hintStyle: Styles.hintTextStyle15,
                          fillColor: HexColor('#F4F3F3'),
                          // labelText: 'Description',
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: CustomColors.inputTextBoarder)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: HexColor('#FF2800'), width: 2.0)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: HexColor('#FF2800'),
                                  width: getHorizontalSize(2))),
                          // prefixIcon: const Icon(Icons.key,
                          //     color: Colors.grey),
                          // suffixIcon: GestureDetector(
                          //   onTap: () {
                          //     // ToastMessage.showMessage("Click");
                          //     _togglevisibility();
                          //   },
                          //   child: Icon(
                          //       _showPassword
                          //           ? Icons.visibility
                          //           : Icons.visibility_off,
                          //       color: CustomColors.appColor),
                          // ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the Description';
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                            getHorizontalSize(20),
                            getVerticalSize(10),
                            getHorizontalSize(20),
                            getVerticalSize(10),
                          ),
                          hintText: "yyyy/mm/dd",
                          hintStyle: Styles.hintTextStyle15,
                          fillColor: HexColor('#F4F3F3'),
                          labelText: 'Car Make Year',
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: CustomColors.inputTextBoarder)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: HexColor('#FF2800'), width: 2.0)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: HexColor('#FF2800'),
                                  width: getHorizontalSize(2))),
                          suffixIcon: IconButton(
                            onPressed: () => _selectDate(context),
                            icon: Icon(
                              Icons.calendar_today,
                              size: getSize(30),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the Date';
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: miellageController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                            getHorizontalSize(20),
                            getVerticalSize(10),
                            getHorizontalSize(20),
                            getVerticalSize(10),
                          ),
                          hintText: "Total run KM",
                          hintStyle: Styles.hintTextStyle15,
                          fillColor: HexColor('#F4F3F3'),
                          labelText: 'Total Miellage',
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: CustomColors.inputTextBoarder)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: HexColor('#FF2800'), width: 2.0)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: HexColor('#FF2800'),
                                  width: getHorizontalSize(2))),
                          // prefixIcon: const Icon(Icons.key,
                          //     color: Colors.grey),
                          // suffixIcon: GestureDetector(
                          //   onTap: () {
                          //     // ToastMessage.showMessage("Click");
                          //     _togglevisibility();
                          //   },
                          //   child: Icon(
                          //       _showPassword
                          //           ? Icons.visibility
                          //           : Icons.visibility_off,
                          //       color: CustomColors.appColor),
                          // ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the Miellage';
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        readOnly: true,
                        controller: _price,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(
                              getHorizontalSize(20),
                              getVerticalSize(10),
                              getHorizontalSize(20),
                              getVerticalSize(10),
                            ),
                            hintText: "Predicted Price",
                            hintStyle: Styles.hintTextStyle15,
                            fillColor: HexColor('#F4F3F3'),
                            labelText: 'Price',
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: CustomColors.inputTextBoarder)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: HexColor('#FF2800'), width: 2.0)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: HexColor('#FF2800'),
                                    width: getHorizontalSize(2))),
                            // prefixIcon: const Icon(Icons.key,
                            //     color: Colors.grey),
                            suffixIcon: _price.text != ''
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _price.clear();
                                      });
                                      // ToastMessage.showMessage("Click");
                                      // _togglevisibility();
                                    },
                                    child: Icon(Icons.clear_sharp,
                                        color: CustomColors.appColor))
                                : SizedBox.shrink()),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: CustomColors.appColor.withOpacity(.4),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: CustomColors.appColor,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            MultiSelectBottomSheetField(
                              initialChildSize: 0.4,
                              listType: MultiSelectListType.CHIP,
                              searchable: true,
                              buttonText: Text(
                                "Troubles in Vehicle",
                                style: Styles.textBlack15B,
                              ),
                              title: Text(
                                "Defects",
                                style: Styles.textBlack15B,
                              ),
                              items: _items,
                              onConfirm: (values) {
                                setState(() {
                                  _selectedDefects = values
                                      .map((item) => item.toString())
                                      .toList();
                                  _selectedDefectString = values
                                      .map((item) => item.toString())
                                      .toList();
                                });
                              },
                              chipDisplay: MultiSelectChipDisplay(
                                onTap: (value) {
                                  setState(() {
                                    _selectedDefects.remove(value);
                                  });
                                },
                              ),
                            ),
                            _selectedDefects == null || _selectedDefects.isEmpty
                                ? Container(
                                    padding: EdgeInsets.all(10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "None selected",
                                      style: Styles.textBlack15B,
                                    ))
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: CustomColors.secondaryColor),
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(8),
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: CustomColors.appColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: imageList.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Image.memory(
                                    imageList[index],
                                    fit: BoxFit.cover,
                                    // height: 90,
                                  ),
                                ),
                                Positioned(
                                  top: -15,
                                  right: -10,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: CustomColors.appColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        imageList.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          selectImage();
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
                              Text('Add Image', style: Styles.textWhite14),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _price.text != ''
                        ? ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (imageList.isEmpty) {
                                  ToastMessage.showMessage(
                                      'Select at least one image');
                                } else {
                                  saveImage(imageList).then((value) => {
                                        FirebaseService.addListing(
                                          Listing(
                                              // kbdksbckbsdkbcsd
                                              id: null,
                                              userId: currentUseruid,
                                              name: nameController.text,
                                              brand: selectedBrand!,
                                              makeYear: dateController.text,
                                              mileage: miellageController.text,
                                              numberOfOwners:
                                                  selectedNumberOfOwners!,
                                              price: _price.text,
                                              description: description.text,
                                              defects: _selectedDefectString,
                                              imageLinks: imageUrls,
                                              purchaserequests: [],
                                              datetime: DateTime.now(),
                                              originalPrice:
                                                  originalpricecontroller.text,
                                              location: location.text),
                                        )
                                            .then((value) => {
                                                  ToastMessage.showMessage(
                                                      'Listing Added'),
                                                  Navigator.of(context).pop(),
                                                })
                                            .catchError((error) {
                                          // Handle the error and show a toast message
                                          ToastMessage.showMessage(
                                              'Failed: $error');
                                        }),
                                      });
                                }
                              } else {
                                ToastMessage.showMessage('Fill all the fields');
                              }

                              // selectImage();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.secondaryColor,
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
                                    Icons.upload_rounded,
                                    color: CustomColors.primaryColour,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text('List Vehicle',
                                      style: Styles.textBlack20B),
                                ],
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                predData(
                                    int.parse(dateController.text),
                                    int.parse(selectedNumberOfOwners ?? '1'),
                                    int.parse(originalpricecontroller.text),
                                    int.parse(miellageController.text));
                                showDialogue(context);
                                // selectImage();
                              } else {
                                ToastMessage.showMessage('Fill all the fields');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.secondaryColor,
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
                                    Icons.perm_device_information,
                                    color: CustomColors.primaryColour,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text('Predict Price',
                                      style: Styles.textBlack20B),
                                ],
                              ),
                            ),
                          ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDialogue(BuildContext context1) {
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
                  'Change Pin',
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
                          fixedSize:
                              Size(getHorizontalSize(100), getVerticalSize(20)),
                          backgroundColor: Colors.transparent,
                        ),
                        child: Center(
                            child: Text('Done', style: Styles.buttonTextStyle)),
                        onPressed: () {
                          this.setState(() {});
                          Navigator.pop(dialogContext);
                        },
                      ),
                    ],
                  ),
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: getVerticalSize(20),
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Predicted Price: ', style: Styles.textWhite14),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: getHorizontalSize(150),
                          height: getVerticalSize(35),
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: getHorizontalSize(10),
                          //     vertical: getVerticalSize(9)),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(getSize(10)),
                            ),
                          ),
                          child: TextFormField(
                            style: Styles.textBlack15B,
                            controller: _price,
                            // focusNode: lastScanNode,
                            decoration: InputDecoration(
                              hintText: 'Predicted Price',
                              hintStyle: Styles.hintTextStyle15,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: getHorizontalSize(10),
                                  vertical: getVerticalSize(5)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(getSize(8)),
                                  borderSide: const BorderSide(
                                      color: CustomColors.inputTextBoarder)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(getSize(8)),
                                  borderSide: const BorderSide(
                                      color: CustomColors.inputTextBoarder)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}
