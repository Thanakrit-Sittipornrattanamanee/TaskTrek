import 'package:flutter/material.dart';
import 'package:planery_exclusive_demo_v1/Screen/Calendar.dart';
import 'package:planery_exclusive_demo_v1/Screen/Profile.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'Shop.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  final screens = [
    Calendar(),
    ProfileScreen(),
    ThemeStore()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TaskTrek!"),
        backgroundColor: Color(0xFFC1DFE3), // Clear Skies
        centerTitle: true,
        automaticallyImplyLeading: false,
        titleTextStyle: TextStyle(color: Color(0xFF548749), fontSize: 20), // English Ivy
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: GNav(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        backgroundColor: Color(0xFFFCF4EA), // Seashell
        color: Color(0xFFBAB759), // Olive Green
        activeColor: Color(0xFF548749), // English Ivy
        tabBackgroundColor: Color(0xFFFECCA5), // Peachy Rose
        onTabChange: (index) => setState(() => currentIndex = index),
        gap: 8,
        tabs: const [
          GButton(
            icon: Icons.calendar_month,
            text: 'Calendar'
          ),
          GButton(
            icon: Icons.person,
            text: 'Profile'
          ),
          GButton(
            icon: Icons.shopping_cart,
            text: 'Shop'
          )
        ],
      ),
    );
  }
}
