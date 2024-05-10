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
        title: const Text("Planery Exclusive! "),
        backgroundColor: Color.fromARGB(255, 183, 123, 239),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: GNav(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        backgroundColor: Color.fromARGB(255, 183, 123, 239),
        color: Colors.black,
        activeColor: Colors.white,
        tabBackgroundColor: Color.fromARGB(255, 185, 131, 235),
        onTabChange: (index) => setState(() => currentIndex = index),
        gap: 8, // ลดค่า gap เพื่อให้แท็บชิดกันมากขึ้น
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
            icon : Icons.shopping_cart,
            text : 'Shop'
          )
        ],
      ),
    );
  }
}
