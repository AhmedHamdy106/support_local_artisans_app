import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/app_colors.dart';
import '../home_view_user/presentation/pages/ProductDetailsScreen.dart';
import '../home_view_user/presentation/pages/ProductModel.dart';
import 'CartItemModel.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());
  final ProductModel? initialProduct;

  CartScreen({super.key, this.initialProduct}) {
    if (initialProduct != null) {
      cartController.cartItems.add(
        CartItemModel(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
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
          ],
        ),
      );
    } else {
      cartController.fetchCartItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text('Cart', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // TODO: search logic
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(child: Text('No items in cart'));
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartModel = cartController.cartItems[index];
                    final item = cartModel.items![0];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: NetworkImage(item.pictureUrl ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                  const SizedBox(height: 4.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 4.0),
                                      Text('${item.brand} \n${item.type}',
                                          style:
                                              const TextStyle(fontSize: 12.0)),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text('EGP ${item.price}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                cartController.cartItems.removeAt(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Obx(() {
                int total =
                    cartController.cartItems.fold<int>(0, (int sum, item) {
                  // Explicitly type 'sum' as int
                  int price = item.items?.first.price ?? 0;
                  int quantity = item.items?.first.quantity ?? 1;
                  return sum + (price * quantity).toInt();
                });
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total price',
                        style: TextStyle(color: Colors.grey.shade600)),
                    Text('EGP $total',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0)),
                  ],
                );
              }),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Checkout logic
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Check Out',
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.0)),
                      SizedBox(width: 8.0),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
