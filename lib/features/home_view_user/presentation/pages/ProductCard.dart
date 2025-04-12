import 'package:flutter/material.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/ProductModel.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap; // 👈 إضافة الـ onTap هنا

  const ProductCard({required this.product, required this.onTap}); // 👈 تعديل المُنشئ ليشمل onTap

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 👈 ربط الـ onTap هنا
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.imageUrl,  // عرض صورة المنتج
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    '\$${product.price}',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
