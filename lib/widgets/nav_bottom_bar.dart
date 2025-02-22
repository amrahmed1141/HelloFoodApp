import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/screens/user/home.dart';
import 'package:foodapp/screens/user/order.dart';
import 'package:foodapp/screens/user/profile.dart';
import 'package:foodapp/screens/user/wallet.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavigationBottom extends StatefulWidget {
  const NavigationBottom({super.key});

  @override
  State<NavigationBottom> createState() => _NavigationBottomState();
}

class _NavigationBottomState extends State<NavigationBottom> {
  int currentIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homePage;
  late Orders orders;
  late Wallet wallet;
  late Profile profile;

  @override
  void initState() {
    homePage = Home();
    orders = Orders();
    wallet = Wallet();
    profile = Profile();

    pages = [homePage, orders, wallet, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GNav(
        backgroundColor: Colors.black,
        color: Colors.white,
        activeColor: Colors.white,
        selectedIndex: currentIndex,
        rippleColor: Colors.black!,
        hoverColor: Colors.white!,

        tabShadow: [
          BoxShadow(color: Colors.black.withOpacity(1), blurRadius: 8)
        ],
        haptic: true,
        tabBorderRadius: 15,
        tabBackgroundColor: Colors.white.withOpacity(0.1),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
        curve: Curves.easeInOut,
        tabMargin: EdgeInsets.symmetric( vertical: 7),
        duration: Duration(milliseconds: 500),
        iconSize: 25,
        onTabChange: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        tabs: [
          GButton(
            icon: Icons.home_outlined,
            text: 'Home',
          ),
          GButton(
            icon: Icons.shopping_bag_outlined,
            text: 'Orders',
          ),
          GButton(
            icon: Icons.wallet_outlined,
            text: 'Wallet',
          ),
          GButton(
            icon: Icons.person_outline,
            text: 'Profile',
          ),
        ],
      ),
      body:pages[currentIndex],
    
    );
  }
}
