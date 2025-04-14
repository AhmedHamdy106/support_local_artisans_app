import 'package:flutter/material.dart';
import 'package:support_local_artisans/features/CartScreen/CartApi.dart';
import 'package:support_local_artisans/features/CartScreen/CartItemModel.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartItemModel>> _cartItemsFuture;

  @override
  void initState() {
    super.initState();
    _cartItemsFuture = CartApi.getCartItems();
  }

  void _refreshCart() {
    setState(() {
      _cartItemsFuture = CartApi.getCartItems();
    });
  }

  Future<void> _removeItem(String itemName) async {
    await CartApi.removeItem(itemName);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$itemName removed from cart")),
    );
    _refreshCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: FutureBuilder<List<CartItemModel>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items in cart'));
          }

          final items = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          item.pictureUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image);
                          },
                        ),
                        title: Text(item.name),
                        subtitle: Text("Qty: ${item.quantity} x ${item.price} LE"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeItem(item.name),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // تنفيذ منطق الدفع
                    // الانتقال إلى صفحة الدفع أو إتمام عملية الشراء
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Proceeding to checkout')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Checkout"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
