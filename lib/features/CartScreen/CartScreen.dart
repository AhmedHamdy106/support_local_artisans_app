import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/features/CartScreen/CartApi.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../config/routes_manager/routes.dart';
import '../home_view_user/presentation/pages/MainScreen.dart';
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
  List<bool> _itemSelections = [];

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
        _itemSelections = List.generate(items.length, (index) => false);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _removeProduct(int productId) async {
    bool success = await CartApi.removeProductFromCart(context, productId);
    if (success) {
      setState(() {
        cartItems.removeWhere((item) => item.id == productId);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('failed_remove_product'.tr())),
      );
    }
  }

  Future<void> _removeAllProducts() async {
    bool success = await CartApi.deleteBasket(context);
    if (success) {
      setState(() {
        cartItems.clear();
        _itemSelections.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('failed_clear_cart'.tr())),
      );
    }
  }

  Future<void> _updateProductQuantity(
      BasketItem item, int newQuantity, int index) async {
    if (newQuantity < 1) return;
    bool success =
        await CartApi.updateProductQuantity(context, item.id!, newQuantity);
    if (success) {
      setState(() {
        item.quantity = newQuantity;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('failed_update_quantity'.tr())),
      );
    }
  }

  double get _totalPayment {
    double total = 0;
    for (int i = 0; i < cartItems.length; i++) {
      if (_itemSelections[i]) {
        total += (cartItems[i].price! * cartItems[i].quantity!);
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        title: Text('cart'.tr(), style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            final role = prefs.getString('role');
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => MainScreen(isMerchant: role == 'Artisan'),
              ),
              (route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: _removeAllProducts,
            icon: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.grey,
              size: 28,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : cartItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/3.0x/Empty Cart3x.png',
                            width: 280,
                            height: 280,
                            filterQuality: FilterQuality.high,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'cart_empty_title'.tr(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'cart_empty_subtitle'.tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 12),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _itemSelections[index],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _itemSelections[index] =
                                              value ?? false;
                                        });
                                      },
                                      activeColor: theme.primaryColor,
                                    ),
                                    Expanded(
                                      child: Card(
                                        elevation: 6,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0.0),
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 4),
                                              SizedBox(
                                                width: 80,
                                                height: 80,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    item.pictureUrl ??
                                                        'https://via.placeholder.com/80',
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const Icon(Icons
                                                          .image_not_supported);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      item.name ?? "اسم المنتج",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: theme.textTheme
                                                            .bodyLarge?.color,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 28),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${item.price}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: theme
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.color,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                            'currency_egp'.tr(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          style: IconButton
                                                              .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            backgroundColor: theme
                                                                .primaryColor,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            minimumSize:
                                                                const Size(
                                                                    15, 15),
                                                          ),
                                                          onPressed: () {
                                                            _updateProductQuantity(
                                                                item,
                                                                item.quantity! -
                                                                    1,
                                                                index);
                                                          },
                                                          icon: const Icon(
                                                              Icons.remove,
                                                              size: 22,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      1.0),
                                                          child: Text(
                                                            item.quantity
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        IconButton(
                                                          style: IconButton
                                                              .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            backgroundColor: theme
                                                                .primaryColor,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            minimumSize:
                                                                const Size(
                                                                    15, 15),
                                                          ),
                                                          onPressed: () {
                                                            _updateProductQuantity(
                                                                item,
                                                                item.quantity! +
                                                                    1,
                                                                index);
                                                          },
                                                          icon: const Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                            size: 22,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.delete_outline,
                                                        size: 28,
                                                        color: Colors.grey,
                                                      ),
                                                      onPressed: () {
                                                        _removeProduct(
                                                            item.id!);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                color: Colors.grey.withOpacity(0.3),
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'total_payment'.tr(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${_totalPayment.toStringAsFixed(0)} ${'currency_egp'.tr()}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _totalPayment > 0
                                      ? () {
                                          Navigator.pushNamed(
                                              context, Routes.paymentRoute);
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.primaryColor,
                                    foregroundColor:
                                        theme.textTheme.labelLarge?.color,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: Text('checkout_now'.tr()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }
}
