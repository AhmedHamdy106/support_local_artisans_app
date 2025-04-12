import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/features/AccountScreen/AccountScreen.dart';
import 'package:support_local_artisans/features/CartScreen/CartScreen.dart';
import 'package:support_local_artisans/features/CategoriesScreen/CategoriesScreen.dart';
import 'package:support_local_artisans/features/CategoriesScreen/CategoryProductScreen.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/CategoryItem.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/CategoryModel.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/HomeApi.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/ProductCard.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/ProductDetailsScreen.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/ProductModel.dart';

class HomeScreenUser extends StatefulWidget {
  @override
  State<HomeScreenUser> createState() => _HomeScreenUserState();
}

class _HomeScreenUserState extends State<HomeScreenUser> {
  int _selectedIndex = 0;
  List<CategoryModel> categories = [];
  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];
  bool isLoading = true;
  String searchText = "";

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final fetchedCategories = await HomeApi.getCategories();
      final fetchedProducts = await HomeApi.getProducts();
      setState(() {
        categories = fetchedCategories;
        products = fetchedProducts;
        filteredProducts = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => isLoading = false);
    }
  }

  // البحث عند الضغط على زر البحث أو "Done"
  void filterProducts() async {
    setState(() {
      searchText = _searchController.text;
      isLoading = true;  // عرض شريط تحميل أثناء البحث
    });

    if (searchText.isEmpty) {
      setState(() {
        filteredProducts = products;  // إذا كان النص فارغًا، عرض جميع المنتجات
        isLoading = false;
      });
    } else {
      final searchResults = await HomeApi.searchProducts(searchText); // استدعاء الـ API
      setState(() {
        filteredProducts = searchResults;
        isLoading = false;
      });
    }
  }

  final List<Widget> _screens = [
    Container(),
    CategoriesScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _selectedIndex == 0
          ? isLoading
          ? buildShimmerGrid()
          : buildMainContent()
          : _screens[_selectedIndex],
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          buildSearchBar(),
          SizedBox(height: 40),
          Text('Categories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          buildCategoriesList(),
          SizedBox(height: 20),
          Text('Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(child: buildProductsGrid()),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,  // ربط الـ FocusNode
            onSubmitted: (_) {
              // يتم البحث عند الضغط على "Done" في الكيبورد
              filterProducts();
            },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: 'Search for anything...',
              hintStyle: TextStyle(color: Color(0xff9D9896), fontSize: 13),
              prefixIcon: IconButton(
                icon: Icon(Icons.search, color: Color(0xff9D9896)),
                onPressed: () {
                  // يتم البحث عند الضغط على زر البحث
                  filterProducts();
                },
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
        SizedBox(width: 12),
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 16,
          child: Icon(Icons.filter_list, color: Color(0xff9D9896), size: 18),
        ),
        SizedBox(width: 10),
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 16,
          child: Icon(Icons.favorite_border, color: Color(0xff9D9896), size: 18),
        ),
      ],
    );
  }

  Widget buildCategoriesList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildCategoryItem(
            name: 'GlassBlowingAndGlass',
            imageUrl:
            'https://i.pinimg.com/736x/4c/0f/81/4c0f81e0c24cbc9165d36f30aa05af05.jpg',
          ),
          buildCategoryItem(
            name: 'Leather',
            imageUrl:
            'https://i.pinimg.com/736x/ce/ed/2b/ceed2b1a638b5656c49f2c0d93937c95.jpg',
          ),
          buildCategoryItem(
            name: 'WeavingAndTextiles',
            imageUrl:
            'https://i.pinimg.com/736x/56/b3/8f/56b38f4b819517ca52bba9bac59ced69.jpg',
          ),
          buildCategoryItem(
            name: 'WoodworkingAndCarpentry',
            imageUrl:
            'https://i.pinimg.com/736x/f6/4b/f7/f64bf7de2e8b974a7c0b3bc56d8ee331.jpg',
          ),
          buildCategoryItem(
            name: 'Pottery',
            imageUrl:
            'https://i.pinimg.com/736x/39/a8/c9/39a8c9a401974f179c90f06b170051f0.jpg',
          ),
        ],
      ),
    );
  }

  Widget buildCategoryItem({required String name, required String imageUrl}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryProductsScreen(categoryName: name),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                width: 75,
                height: 75,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildProductsGrid() {
    if (filteredProducts.isEmpty) {
      return Center(child: Text("No products found."));
    }
    return GridView.builder(
      padding: EdgeInsets.only(top: 10),
      itemCount: filteredProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // عند الضغط على المنتج، يتم الانتقال إلى صفحة تفاصيل المنتج
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailsScreen(product: filteredProducts[index]),
              ),
            );
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: ProductCard(
              product: filteredProducts[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(product: filteredProducts[index]),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }


  Widget buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
      ],
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Color(0xff9D9896),
      showUnselectedLabels: true,
      backgroundColor: AppColors.primary,
      iconSize: 24,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
