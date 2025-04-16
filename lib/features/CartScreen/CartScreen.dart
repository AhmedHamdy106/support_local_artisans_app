import 'package:flutter/material.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/features/CartScreen/CartApi.dart';
import '../../config/routes_manager/routes.dart';
import 'BasketItem.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<BasketItem> cartItems = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCartData();
  }

  Future<void> _fetchCartData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final items = await CartApi.getBasketItems();
      setState(() {
        cartItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // Handle deleting a single product
  Future<void> _removeProduct(BasketItem item) async {
    String basketId = '5e04bebb-7502-4f59-ab51-cae308d6bdb5'; // معرّف السلة
    bool success = await CartApi.removeProductFromCart(context, basketId);
    if (success) {
      setState(() {
        cartItems.remove(item); // إزالة المنتج من الواجهة بعد الحذف
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove product')),
      );
    }
  }


  // Handle deleting all products
  Future<void> _removeAllProducts() async {
    bool success = await CartApi.removeAllProductsFromCart(context);
    if (success) {
      setState(() {
        cartItems.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to clear cart')),
      );
    }
  }
  // Handle updating product quantity
  Future<void> _updateProductQuantity(BasketItem item, int newQuantity) async {
    if (newQuantity < 1) return; // لا تسمح بأن تكون الكمية أقل من 1
    bool success = await CartApi.updateProductQuantity(context, item.id!, newQuantity);
    if (success) {
      setState(() {
        item.quantity = newQuantity; // تحديث الكمية في الواجهة
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update product quantity')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, Routes.homeRoute),
        ),
        actions: [
          IconButton(
            onPressed: _removeAllProducts, // Clear cart
            icon: const Icon(Icons.delete),
          ),
        ],
        title: const Text('Cart Screen'),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      )
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : // Update quantity in ListView.builder inside the CartScreen
      ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: SizedBox(
                      width: 80.0,
                      height: 80.0,
                      child: Image.network(
                        item.pictureUrl ?? 'https://via.placeholder.com/80',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported_outlined,
                            size: 40.0,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? "",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        Text('${item.price} EGP',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2.0),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: item.quantity! > 1
                                  ? () => _updateProductQuantity(item, item.quantity! - 1)
                                  : null,
                            ),
                            Text('Quantity: ${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _updateProductQuantity(item, item.quantity! + 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _removeProduct(item),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      )

      ,
      bottomNavigationBar: cartItems.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // تنفيذ الشراء
            Navigator.pushNamed(context, Routes.paymentRoute);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8C4931),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Checkout'),
        ),
      )
          : null,
    );
  }
}
