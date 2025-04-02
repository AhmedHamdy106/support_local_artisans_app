import 'package:flutter/material.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 69,
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Search for anything...',
                      hintStyle: const TextStyle(
                          color: Color(0xff9D9896),
                          fontSize: 13,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400),
                      prefixIcon: const ImageIcon(
                        AssetImage(
                          "assets/icons/3.0x/icon-park-outline_search_3.0x.png",
                        ),
                        color: Color(0xff9D9896),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 35,
                        minHeight: 35,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ImageIcon(
                      AssetImage(
                        "assets/icons/3.0x/mage_filter-fill_3.0x.png",
                      ),
                      color: Color(0xff9D9896),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const SizedBox(
                  height: 32,
                  width: 32,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child:
                        Icon(Icons.favorite_border, color: Color(0xff9D9896)),
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
              ],
            ),
            SizedBox(height: 40),
            Text(
              'Categories',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryItem('Carpets',
                      'https://tse2.mm.bing.net/th?id=OIP.9W7lcpkgip2VSzUhjHxsRAAAAA&pid=Api'),
                  CategoryItem('Pottery',
                      'https://tse4.mm.bing.net/th?id=OIP.ZhqHlXNJFUwoTG7sepTjtAHaHa&pid=Api'),
                  CategoryItem('Clothes',
                      'https://tse2.mm.bing.net/th?id=OIP.qrGcPLST1ww2Sv3LXbs1pgHaGY&pid=Api'),
                  CategoryItem('Bags',
                      'https://tse2.mm.bing.net/th?id=OIP.1ZNSSbH12rOpWHdYXjWtjwHaFi&pid=Api'),
                  CategoryItem('Jewelry',
                      'https://tse2.mm.bing.net/th?id=OIP.m1a8Tdbua9lofljDlPTP8wHaFj&pid=Api'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Products',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ProductCard();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                  "assets/icons/3.0x/material-symbols_home-rounded_3.0x.png"),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Image.asset(
                  "assets/icons/3.0x/iconamoon_category-fill_3.0x.png"),
              label: 'Categories'),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/3.0x/mdi_cart_3.0x.png"),
              label: 'Cart'),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/3.0x/mdi_account_3.0x.png"),
              label: 'Account'),
        ],
        currentIndex: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xff9D9896),
        showUnselectedLabels: true,
        backgroundColor: AppColors.primary,
        iconSize: 24,
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  CategoryItem(this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imageUrl),
          ),
          SizedBox(height: 4),
          Text(title),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://tse4.mm.bing.net/th?id=OIP.ZhqHlXNJFUwoTG7sepTjtAHaHa&pid=Api'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pottery Vase',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(' 4.8'),
                  ],
                ),
                Text('285 LE', style: TextStyle(color: AppColors.background)),
                Text(
                  '315 LE',
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
