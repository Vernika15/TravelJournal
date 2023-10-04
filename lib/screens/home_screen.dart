import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import '../data_manager/home_data_manager.dart';
import '../data_manager/home_screen_data.dart';
import '../utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeDataManager>(context);

    return Scaffold(
      bottomNavigationBar: Container(
        // color: gradientColors[2],
        child: Container(
          margin: const EdgeInsets.only(bottom: 35.0, left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: gradientColors[0],
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            child: GNav(
              color: whiteColor,
              activeColor: whiteColor,
              tabBackgroundColor: whiteColor.withOpacity(0.3),
              gap: 8,
              iconSize: 28,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: whiteColor,
                fontSize: 14,
              ),
              padding: const EdgeInsets.all(8.0),
              tabs: bottomNavBarTabs,
              selectedIndex: homeProvider.selectedIndex,
              onTabChange: (index) {
                homeProvider.setIndex(index);
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: widgetOptions.elementAt(
          homeProvider.selectedIndex,
        ),
      ),
    );
  }
}
