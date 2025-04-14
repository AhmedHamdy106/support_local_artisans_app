import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support_local_artisans/features/CartScreen/CartScreen.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/ProductModel.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/features/CartScreen/CartApi.dart';
import 'package:support_local_artisans/features/CartScreen/CartItemModel.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          product.title,
          style: TextStyle(color: Colors.black, fontSize: 18.sp),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // تنفيذ منطق البحث
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {
              // الانتقال إلى صفحة العربة
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()), // الانتقال إلى سلة المشتريات
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.sp),
        child: ListView(
          children: [
            Container(
              height: 300.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.network(
                    product.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    height: 300.h,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.broken_image));
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              product.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'EGP ${product.price}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    'Sold: 3200',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                  ),
                ),
                SizedBox(width: 8.w),
                const Icon(Icons.star, color: Colors.amber, size: 16),
                SizedBox(width: 4.w),
                Text(
                  '4.8 (750)',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text(
              'Description',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              product.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total price',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                    ),
                    Text(
                      'EGP ${product.price}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final cartItem = CartItemModel(
                      id: product.id,
                      name: product.title,
                      price: product.price.toInt(),  // Ensure price is int
                      quantity: 1,
                      pictureUrl: product.imageUrl,
                      brand: product.brand,
                      type: product.type,
                    );
                    final success = await CartApi.addToCart(
                      id: cartItem.id,
                      name: cartItem.name,
                      price: cartItem.price,
                      quantity: cartItem.quantity,
                      pictureUrl: cartItem.pictureUrl,
                      brand: cartItem.brand,
                      type: cartItem.type,
                    );
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added to cart!')),
                      );
                      // الانتقال إلى صفحة العربة مباشرة بعد الإضافة
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartScreen()), // الانتقال إلى سلة المشتريات
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add to cart')),
                      );
                    }
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
