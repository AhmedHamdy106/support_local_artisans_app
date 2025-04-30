import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import 'ProductModel.dart'; // عشان الـ Artisan model

class ArtisanDetailsScreen extends StatelessWidget {
  final Artisan artisan;
  // ممكن نضيف هنا قائمة بمنتجات الحرفي لو كنا جايبينها مع بيانات الحرفي
  // final List<ProductModel>? artisanProducts;

  const ArtisanDetailsScreen(
      {super.key, required this.artisan /*, this.artisanProducts*/});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access current theme

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Use theme background color
      appBar: AppBar(
        title: const Text(
          'Artisan Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: theme.primaryColor, // Use primary color from theme
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // صورة البروفايل الدائرية
            const SizedBox(
              height: 30,
            ),
            CircleAvatar(
              radius: 60.0,
              backgroundImage: const NetworkImage(
                  'https://i.pinimg.com/474x/d4/ff/c5/d4ffc51096749df430c5dee85ef57cd4.jpg'), // Replace with actual URL
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 16.0),
            // اسم العرض
            Text(
              artisan.displayName ?? 'N/A',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color, // Use text color from theme
              ),
            ),
            const SizedBox(height: 8.0),
            // معلومات أساسية
            Text(
              'Email: ${artisan.email ?? 'N/A'}',
              style: TextStyle(color: theme.textTheme.bodyMedium?.color), // Use secondary text color from theme
            ),
            const SizedBox(height: 4.0),
            Text(
              'Phone: ${artisan.phoneNumber ?? 'N/A'}',
              style: TextStyle(color: theme.textTheme.bodyMedium?.color), // Use secondary text color from theme
            ),
            const SizedBox(height: 16.0),
            // نبذة عن الحرفي (لو فيه)
            const Text(
              'About Me',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'A passionate leather craftsman with over 10 years of experience in creating high-quality and unique leather goods. Dedicated to preserving traditional techniques while embracing modern designs.', // Replace with actual bio
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24.0),
            // قائمة المنتجات (لو كنا جايبينها)
            const Text(
              'Products by This Artisan',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12.0),
            // هنستخدم GridView لعرض المنتجات بشكل منظم
            // artisanProducts != null && artisanProducts!.isNotEmpty
            //     ? GridView.builder(
            //         shrinkWrap: true,
            //         physics: const NeverScrollableScrollPhysics(),
            //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //           crossAxisCount: 2,
            //           childAspectRatio: 0.75,
            //           crossAxisSpacing: 8.0,
            //           mainAxisSpacing: 8.0,
            //         ),
            //         itemCount: artisanProducts!.length,
            //         itemBuilder: (context, index) {
            //           final product = artisanProducts![index];
            //           return Card(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Expanded(
            //                   child: Image.network(
            //                     product.pictureUrl ?? 'URL_TO_DEFAULT_IMAGE',
            //                     fit: BoxFit.cover,
            //                     width: double.infinity,
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Text(
            //                     product.name ?? 'Product Name',
            //                     style: const TextStyle(fontWeight: FontWeight.bold),
            //                     maxLines: 2,
            //                     overflow: TextOverflow.ellipsis,
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //                   child: Text('\$${product.price?.toStringAsFixed(2) ?? 'N/A'}'),
            //                 ),
            //               ],
            //             ),
            //           );
            //         },
            //       )
            //     : const Text('No products available from this artisan.'),
            const SizedBox(height: 24.0),
            // زر التواصل
            ElevatedButton.icon(
              onPressed: () {
                // هنا ممكن نضيف logic للتواصل مع الحرفي (فتح إيميل، بدء مكالمة، إلخ)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Contacting ${artisan.displayName ?? 'Artisan'}...')),
                );
              },
              icon: const Icon(
                Icons.message_outlined,
                color: Colors.white,
              ),
              label: const Text('Contact Artisan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor, // Use primary color from theme
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
