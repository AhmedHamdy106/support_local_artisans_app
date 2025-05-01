import 'package:flutter/material.dart';
import 'package:support_local_artisans/features/CartScreen/CartScreen.dart';
import 'package:support_local_artisans/features/AccountScreen/ProfileScreen.dart';
import 'package:support_local_artisans/features/CategoriesScreen/CategoriesScreen.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/home_screen_user.dart';
import '../../../home_view_artisan/AddProductScreen.dart';
import '../../../home_view_artisan/MyProductsScreen.dart';
import 'package:easy_localization/easy_localization.dart';

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
            BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                label: 'home'.tr()), // الترجمة
            BottomNavigationBarItem(
                icon: const Icon(Icons.category_outlined),
                label: 'categories'.tr()), // الترجمة
            BottomNavigationBarItem(
                icon: const Icon(Icons.storefront_outlined),
                label: 'my_products'.tr()), // الترجمة
            BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                label: 'account'.tr()), // الترجمة
          ]
        : [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                label: 'home'.tr()), // الترجمة
            BottomNavigationBarItem(
                icon: const Icon(Icons.category_outlined),
                label: 'categories'.tr()), // الترجمة
            BottomNavigationBarItem(
                icon: const Icon(Icons.shopping_cart_outlined),
                label: 'cart'.tr()), // الترجمة
            BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                label: 'account'.tr()), // الترجمة
          ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access current theme

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor, // Use theme background color
      body: _screens[_currentIndex],
      floatingActionButton: widget.isMerchant
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductScreen()),
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
              backgroundColor: theme.primaryColor, // Use theme primary color
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (index) {
              if (index == 2) {
                return const SizedBox(width: 40); // مكان الزرار
              }

              final actualIndex = index > 2 ? index - 1 : index;
              final item = _navItems[actualIndex];

              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _currentIndex = actualIndex),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconTheme(
                        data: IconThemeData(
                          color: _currentIndex == actualIndex
                              ? theme.primaryColor // Use theme primary color
                              : theme.iconTheme.color, // Use theme icon color
                        ),
                        child: item.icon!,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label!,
                        style: TextStyle(
                          color: _currentIndex == actualIndex
                              ? theme.primaryColor // Use theme primary color
                              : theme.textTheme.bodyMedium
                                  ?.color, // Use theme text color
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
