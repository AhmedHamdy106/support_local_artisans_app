import 'package:flutter/material.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/ProductModel.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap; // 👈 إضافة الـ onTap هنا

  const ProductCard({required this.product, required this.onTap}); // 👈 تعديل المُنشئ ليشمل onTap

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access current theme

    return GestureDetector(
      onTap: onTap, // 👈 ربط الـ onTap هنا
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: theme.cardColor, // Use the card color from the theme
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: theme.textTheme.bodyLarge?.color), // Use theme text color
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    product.description!,
                    maxLines: 2, // تحديد أقصى عدد للسطور هنا
                    overflow:
                    TextOverflow.ellipsis, // إضافة علامة حذف لو النص طويل
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: theme.textTheme.bodyMedium?.color), // Use theme text color
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
                            color: theme.textTheme.bodyLarge?.color, fontSize: 14), // Use theme text color
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
