import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/app_colors.dart';
import '../home_view_user/presentation/pages/ProductDetailsScreen.dart';
import '../home_view_user/presentation/pages/ProductModel.dart';
import 'CartItemModel.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());
  final ProductModel? initialProduct; // استقبال المنتج كـ Parameter

  CartScreen({super.key, this.initialProduct}) {
    final initialProduct = this.initialProduct;
    if (initialProduct != null) {
      // يمكنك هنا إضافة المنتج مباشرة إلى الكنترولر أو عمل أي منطق تريده
      print('Received product in CartScreen: ${initialProduct.title}');
      // مثال بسيط لإضافة المنتج مباشرة (قد تحتاج تعديل حسب منطق عربة التسوق)
      cartController.cartItems.add(CartItemModel(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}', // معرف مؤقت
          items: [
            Items(
              id: initialProduct!.id,
              name: initialProduct!.title,
              pictureUrl: initialProduct!.imageUrl,
              price: initialProduct!.price.toInt(),
              brand: initialProduct!.brand,
              type: initialProduct!.type,
              quantity: 1,
            ),
          ]));
    } else {
      cartController.fetchCartItems(); // جلب بيانات عربة التسوق الموجودة
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Cart")),
      body: Obx(() {
        if (cartController.cartItems.isEmpty && initialProduct == null) {
          return const Center(child: Text('No items in cart'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: cartController.cartItems.length,
          itemBuilder: (context, index) {
            final cartModel = cartController.cartItems[index] as CartItemModel;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  // ... (باقي تصميم عرض عناصر الكارت)
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.network(
                        cartModel.items![0].pictureUrl ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartModel.items![0].name ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("${cartModel.items![0].price} LE"),
                          // ... (باقي تفاصيل المنتج والكمية وأزرار التحكم)
                        ],
                      ),
                    ),
                    // ... (زر الحذف)
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: cartController.fetchCartItems,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
