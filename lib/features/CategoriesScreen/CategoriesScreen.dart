import 'package:flutter/material.dart';
import 'package:support_local_artisans/features/CategoriesScreen/CategoryProductScreen.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/CategoryModel.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/shared/shared_preference.dart';
import '../home_view_user/presentation/pages/MainScreen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<CategoryModel> categories = [
    CategoryModel(
        id: 1,
        name: 'Glass',
        imageUrl:
            'https://i.pinimg.com/736x/4c/0f/81/4c0f81e0c24cbc9165d36f30aa05af05.jpg'),
    CategoryModel(
        id: 2,
        name: 'Leather',
        imageUrl:
            'https://i.pinimg.com/736x/ce/ed/2b/ceed2b1a638b5656c49f2c0d93937c95.jpg'),
    CategoryModel(
        id: 3,
        name: 'WeavingAndTextiles',
        imageUrl:
            'https://i.pinimg.com/736x/56/b3/8f/56b38f4b819517ca52bba9bac59ced69.jpg'),
    CategoryModel(
        id: 4,
        name: 'Wood',
        imageUrl:
            'https://i.pinimg.com/736x/f6/4b/f7/f64bf7de2e8b974a7c0b3bc56d8ee331.jpg'),
    CategoryModel(
        id: 5,
        name: 'PotteryAndCeramics',
        imageUrl:
            'https://i.pinimg.com/736x/39/a8/c9/39a8c9a401974f179c90f06b170051f0.jpg'),
  ];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            final role = await SharedPreference.getData(key: 'role');
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => MainScreen(isMerchant: role == 'Artisan'),
              ),
              (route) => false,
            );
          },
        ),
        title: Text(
          "Categories",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                children: [
                  for (var category in categories)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryProductsScreen(
                                categoryName: category.name,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 3,
                          color: AppColors.background,
                          margin: EdgeInsets.symmetric(vertical: 10.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r)),
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 80.w,
                                  height: 80.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Image.network(
                                      category.imageUrl,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                            Icons.image_not_supported);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Text(
                                    category.name,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios,
                                    color: Colors.grey.shade500),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
