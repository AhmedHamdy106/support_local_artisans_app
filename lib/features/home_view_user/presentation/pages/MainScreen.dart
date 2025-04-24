import 'package:flutter/material.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/features/CartScreen/CartScreen.dart';
import 'package:support_local_artisans/features/AccountScreen/ProfileScreen.dart';
import 'package:support_local_artisans/features/CategoriesScreen/CategoriesScreen.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/home_screen_user.dart';
import '../../../home_view_artisan/AddProductScreen.dart';
import '../../../home_view_artisan/MyProductsScreen.dart';

class MainScreen extends StatefulWidget {
  final bool isMerchant;

  const MainScreen({super.key, required this.isMerchant});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late List<Widget> _screens;
  late List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();

    _screens = widget.isMerchant
        ? [
            const HomeScreenUser(),
            const CategoriesScreen(),
            const MyProductsScreen(),
            const AccountScreen(),
          ]
        : [
            const HomeScreenUser(),
            const CategoriesScreen(),
            const CartScreen(),
            const AccountScreen(),
          ];

    _navItems = widget.isMerchant
        ? [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Home"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined), label: "Categories"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.storefront_outlined), label: "My Products"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: "Account"),
          ]
        : [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Home"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined), label: "Categories"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: "Account"),
          ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_currentIndex],
      floatingActionButton: widget.isMerchant && _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductScreen()),
                );
              },
              label: const Text("Add Product"),
              icon: const Icon(Icons.add),
              backgroundColor: AppColors.primary,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _navItems,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xff9D9896),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}
