// cart_screen.dart
import 'package:flutter/material.dart';
import 'package:support_local_artisans/features/CartScreen/CartApi.dart';
import 'package:support_local_artisans/features/CartScreen/CartItemModel.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: FutureBuilder<List<CartItemModel>>(
        future: CartApi.getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
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
                        title: Text(item.name),
                        subtitle:
                        Text("Qty: \${item.quantity} x \${item.price} LE"),
                        trailing:
                        const Icon(Icons.delete, color: Colors.red),
                        onTap: () {
                          // Remove item logic
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Proceed to checkout logic
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
