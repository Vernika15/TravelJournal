import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../screens/journal_screens/add_journal_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/profile_screen.dart';
import '../utils/constants.dart';

final List<Widget> widgetOptions = <Widget>[
  const DashboardScreen(),
  const AddJournalScreen(),
  const ProfileScreen(),
];

final bottomNavBarTabs = [
  GButton(
    icon: Icons.home,
    text: home,
    margin: const EdgeInsets.all(5.0),
    borderRadius: BorderRadius.circular(30.0),
  ),
  GButton(
    icon: Icons.add,
    text: addJournal,
    margin: const EdgeInsets.all(5.0),
    borderRadius: BorderRadius.circular(30.0),
  ),
  GButton(
    icon: Icons.person,
    text: profile,
    margin: const EdgeInsets.all(5.0),
    borderRadius: BorderRadius.circular(30.0),
  ),
];
