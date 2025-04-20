import 'package:flutter/material.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/ProductModel.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap; // 👈 إضافة الـ onTap هنا

  const ProductCard(
      {required this.product,
      required this.onTap}); // 👈 تعديل المُنشئ ليشمل onTap

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 👈 ربط الـ onTap هنا
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.pictureUrl!,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 65.0),
                    child: Center(
                        child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 45,
                    )),
                  );
                },
                fit: BoxFit.cover,
                width: double.infinity,
                height: 110,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name!,
                    maxLines: 1, // تحديد أقصى عدد للسطور هنا
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    product.description!,
                    maxLines: 2, // تحديد أقصى عدد للسطور هنا
                    overflow:
                        TextOverflow.ellipsis, // إضافة علامة حذف لو النص طويل
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: AppColors.textSecondary),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${product.price} EGP',
                        style: TextStyle(
                            color: AppColors.textPrimary, fontSize: 14),
                      ),
                    ],
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
