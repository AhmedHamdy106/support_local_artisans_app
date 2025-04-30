import 'package:flutter/material.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/ArtisianDetailsScreen.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../CartScreen/CartApi.dart';
import '../../../CartScreen/CartScreen.dart';
import 'ProductModel.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel? product;

  const ProductDetailsScreen({super.key, this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Use theme background color
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor, // Use theme background color
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.iconTheme.color), // Use theme icon color
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Product Details', style: TextStyle(color: theme.textTheme.bodyLarge?.color)), // Use theme text color
        actions: [
          IconButton(
              icon: Icon(Icons.shopping_cart_outlined, color: theme.iconTheme.color), // Use theme icon color
              onPressed: () {}),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.5), width: 2.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: SizedBox(
                          height: 250.0,
                          child: Image.network(
                            widget.product?.pictureUrl ?? "",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 40.0);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product?.name ?? "",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: theme.textTheme.bodyLarge?.color), // Use theme text color
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Text(
                          '3,230 Sold',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      const Text('4.8', style: TextStyle(color: Colors.grey)),
                      SizedBox(
                        width: 105,
                      ),
                      Text(
                        '${widget.product!.price?.toInt()} EGP',
                        style: TextStyle(
                            color: theme.textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w600), // Use theme text color
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Description',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text(
                    widget.product?.description ?? "",
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color), // Use theme text color
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade200))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ✅ صف الـ Row اللي فيه الزر والأيقونة
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final bool isAdded = await CartApi.addProductToCart(
                        context, widget.product ?? ProductModel());
                    if (isAdded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Product added to cart!')),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    }
                  },
                  icon:
                  Icon(Icons.add_shopping_cart, color: theme.iconTheme.color), // Use theme icon color
                  label: Text('Add to cart', style: TextStyle(color: theme.textTheme.bodyLarge?.color)), // Use theme text color
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor, // Use theme primary color
                    foregroundColor: theme.buttonTheme.colorScheme?.onPrimary, // Use theme text color for button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 16.0), // مسافة بين الزر والأيقونة
                // ✅ الأيقونة الجديدة اللي هتودي لصفحة بيانات الحرفي
                InkWell(
                  onTap: () {
                    if (widget.product?.artisan != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArtisanDetailsScreen(
                              artisan: widget.product!.artisan!),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('No artisan information available.')),
                      );
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 80.0),
                        child: Icon(
                          Icons.person_pin,
                          size: 30.0,
                          color: theme.iconTheme.color, // Use theme icon color
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 72.0),
                        child: Text(
                          'Artisan Profile',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: theme.textTheme.bodyMedium?.color, // Use theme text color
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // ممكن نضيف هنا أيقونة تانية لو محتاجين
          ],
        ),
      ),
    );
  }
}
