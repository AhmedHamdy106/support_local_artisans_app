import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:support_local_artisans/features/CategoriesScreen/CategoryProductScreen.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/CategoryModel.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/HomeApi.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/ProductCard.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/ProductDetailsScreen.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/ProductModel.dart';

class HomeScreenUser extends StatefulWidget {
  const HomeScreenUser({super.key});

  @override
  State<HomeScreenUser> createState() => _HomeScreenUserState();
}

class _HomeScreenUserState extends State<HomeScreenUser> {
  List<CategoryModel> categories = [];
  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];
  List<ProductModel> recommendations = []; // لحفظ التوصيات
  bool isLoading = true;
  String searchText = "";

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    fetchData();
    _searchController.addListener(onSearchTextChanged); // إضافة مراقب لحقل النص
  }

  Future<void> fetchData() async {
    try {
      final fetchedCategories = await HomeApi.getCategories();
      final fetchedProducts = await HomeApi.getProducts();
      setState(() {
        categories = fetchedCategories;
        products = fetchedProducts;
        filteredProducts = fetchedProducts;
        recommendations = [];
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => isLoading = false);
    }
  }

  void onSearchTextChanged() {
    // التأخير باستخدام debounce لمنع تنفيذ البحث في كل حرف يتم كتابته
    setState(() {
      searchText = _searchController.text;
    });
    filterProducts();
  }

  void onSearchSubmit(String value) {
    // إخفاء الترشيحات عندما يضغط المستخدم على Enter أو "OK"
    setState(() {
      recommendations = []; // إخفاء الترشيحات
    });
    filterProducts(); // يمكن تنفيذ البحث هنا إذا أردت
  }

  void filterProducts() {
    setState(() {
      isLoading = true;
    });

    if (searchText.isEmpty) {
      setState(() {
        recommendations = []; // إخفاء التوصيات عندما لا يكون هناك نص
        filteredProducts = products; // إظهار جميع المنتجات
        isLoading = false;
      });
    } else {
      final filtered = products.where((product) {
        return product.name!.toLowerCase().contains(searchText.toLowerCase());
      }).toList();

      setState(() {
        recommendations = filtered; // وضع التوصيات في القائمة
        filteredProducts = filtered; // تحديث المنتجات بناءً على البحث
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access current theme

    return isLoading ? buildShimmerGrid() : buildMainContent(theme);
  }

  Widget buildMainContent(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.h),
          buildSearchBar(theme),
          SizedBox(height: 40.h),
          Text('Categories', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)),
          SizedBox(height: 10.h),
          buildCategoriesList(),
          SizedBox(height: 20.h),
          Text('Products', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)),
          Expanded(child: buildProductsGrid(theme)),
        ],
      ),
    );
  }

  Widget buildSearchBar(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                onSubmitted: onSearchSubmit, // تعديل ليكون الدالة الجديدة
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Search for anything...',
                  hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 13.sp),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.search, color: theme.iconTheme.color, size: 28.sp),
                    onPressed: filterProducts,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        // الترشيحات تظهر تحت مربع البحث
        if (recommendations.isNotEmpty && searchText.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.transparent, // خلفية شفافة
              boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5, offset: Offset(0, 2))],
            ),
            child: Container(
              height: 200.h,  // الحد من ارتفاع الـ Container لترشيحات البحث
              child: ListView.builder(
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final product = recommendations[index];
                  return ListTile(
                    title: Text(
                      product.name != null ? product.name! : 'منتج غير معروف',
                      style: TextStyle(color: theme.textTheme.bodyMedium?.color), // تغيير اللون إلى اللون الثانوي من الثيم
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget buildCategoriesList() {
    final categoryList = [
      {
        'name': 'Glass',
        'image': 'https://i.pinimg.com/736x/4c/0f/81/4c0f81e0c24cbc9165d36f30aa05af05.jpg'
      },
      {
        'name': 'Leather',
        'image': 'https://i.pinimg.com/736x/ce/ed/2b/ceed2b1a638b5656c49f2c0d93937c95.jpg'
      },
      {
        'name': 'WeavingAndTextiles',
        'image': 'https://i.pinimg.com/736x/56/b3/8f/56b38f4b819517ca52bba9bac59ced69.jpg'
      },
      {
        'name': 'Wood',
        'image': 'https://i.pinimg.com/736x/f6/4b/f7/f64bf7de2e8b974a7c0b3bc56d8ee331.jpg'
      },
      {
        'name': 'PotteryAndCeramics',
        'image': 'https://i.pinimg.com/736x/39/a8/c9/39a8c9a401974f179c90f06b170051f0.jpg'
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categoryList
            .map((cat) => buildCategoryItem(name: cat['name']!, imageUrl: cat['image']!))
            .toList(),
      ),
    );
  }

  Widget buildCategoryItem({required String name, required String imageUrl}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CategoryProductsScreen(categoryName: name)),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(right: 14.w),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(imageUrl, width: 75.w, height: 75.h, fit: BoxFit.cover),
            ),
            SizedBox(height: 6.h),
            Text(name, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Theme.of(context).textTheme.bodyLarge?.color))
          ],
        ),
      ),
    );
  }

  Widget buildProductsGrid(ThemeData theme) {
    if (filteredProducts.isEmpty) {
      return Center(child: Text("No products found.", style: TextStyle(fontSize: 14.sp, color: theme.textTheme.bodyMedium?.color)));
    }
    return GridView.builder(
      padding: EdgeInsets.only(top: 10.h),
      itemCount: filteredProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 0.66,
      ),
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutBack,
            child: ProductCard(
              product: product,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
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
      padding: EdgeInsets.all(16.w),
      child: GridView.builder(
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 8.w,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade400,
            highlightColor: Colors.grey.shade200,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
