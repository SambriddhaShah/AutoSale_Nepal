import 'package:auto_sale_nepal/Constants/customColors.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/BottomNavBar/NavItem/FavouritePage.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/BottomNavBar/NavItem/HomePage.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/BottomNavBar/NavItem/MyListings.dart';
import 'package:auto_sale_nepal/Screens/MainScreens/BottomNavBar/NavItem/userPfofilePage.dart';
import 'package:auto_sale_nepal/Utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  String? search;
  int currentIndex = 0;
  late List _pages;

  void changePage(int index, String sear) {
    setState(() {
      _pages = [
        HomePage(
            navigateToTab: // Call changePage function to update currentIndex
                changePage),
        MyListingsPage(
          search: sear,
        ),
        FavouritePage(),
        ProfilePage()
      ];
    });

    print('the search on nav page is $sear and the search become $search');
    changeIndex(index);
  }

  void changeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    setState(() {
      _pages = [
        HomePage(
            navigateToTab: // Call changePage function to update currentIndex
                changePage),
        MyListingsPage(
          search: search ?? '',
        ),
        FavouritePage(),
        ProfilePage()
      ];
    });

    super.initState();
  }

  void goToPage(index) {
    setState(() {
      _pages = [
        HomePage(
            navigateToTab: // Call changePage function to update currentIndex
                changePage),
        MyListingsPage(
          search: search ?? '',
        ),
        FavouritePage(),
        ProfilePage()
      ];
    });
    currentIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: GNav(
        // rippleColor: CustomColors.secondaryColor,
        // tabActiveBorder:
        //     Border.all(color: CustomColors.secondaryColor, width: getSize(2)),
        activeColor: CustomColors.secondaryColor,
        backgroundColor: CustomColors.appColor,
        onTabChange: (index) => goToPage(index),
        selectedIndex: currentIndex,
        tabs: [
          GButton(
            icon: Icons.home,
            text: 'Home',
            textStyle: Styles.textWhite14,
            iconColor: CustomColors.secondaryColor,
          ),
          GButton(
            icon: Icons.car_crash_outlined,
            text: 'Listings',
            textStyle: Styles.textWhite14,
            iconColor: CustomColors.secondaryColor,
          ),
          GButton(
            icon: Icons.favorite_border_rounded,
            text: 'Interested',
            textStyle: Styles.textWhite14,
            iconColor: CustomColors.secondaryColor,
          ),
          GButton(
            icon: Icons.person_2_outlined,
            text: 'Profile',
            textStyle: Styles.textWhite14,
            iconColor: CustomColors.secondaryColor,
          )
        ],
      ),
    );
  }
}
