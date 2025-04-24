import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/features/CartScreen/CartApi.dart';
import '../../config/routes_manager/routes.dart';
import '../../core/shared/shared_preference.dart';
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
        const SnackBar(content: Text('Failed to remove product from cart')),
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
        const SnackBar(content: Text('Failed to clear cart')),
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
        const SnackBar(content: Text('Failed to update product quantity')),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            final role = await SharedPreference.getData(key: 'role');
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => MainScreen(isMerchant: role == 'Artisan'),
              ),
                  (route) => false,
            );
          },
        ),
        title: const Text('Cart', style: TextStyle(color: Colors.black)),
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
              'assets/images/3.0x/Empty Cart3x.png', // استبدل ده بمسار الصورة بتاعتك
              width: 280.w,
              height: 280.h,
              filterQuality: FilterQuality.high,
            ),
            const SizedBox(height: 20),
            const Text(
              'Oops your Cart is empty!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'There are no items in your cart yet.\nTake a look at our products',
              textAlign: TextAlign.center,
              style: TextStyle(
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
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 12.h),
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
                        activeColor: AppColors.primary,
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        child: Card(
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 75.w,
                                  height: 75.h,
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(10.r),
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
                                SizedBox(width: 10.w),
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
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 12.sp),
                                        maxLines: 2,
                                        overflow: TextOverflow
                                            .ellipsis,
                                      ),
                                      SizedBox(height: 35.h),
                                      Row(
                                        children: [
                                          Text(
                                              '${item.price}',
                                              style: TextStyle(
                                                  fontSize: 12.sp)),
                                          SizedBox(width: 4.w),
                                          const Text('EGP',
                                              style: TextStyle(
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      style: IconButton.styleFrom(
                                        shape:
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(20.r),
                                        ),
                                        backgroundColor:
                                        AppColors.primary,
                                        padding: EdgeInsets.zero,
                                        minimumSize:
                                        Size(15.w, 15.h),
                                      ),
                                      onPressed: () {
                                        _updateProductQuantity(
                                            item,
                                            item.quantity! - 1,
                                            index);
                                      },
                                      icon: const Icon(
                                          Icons.remove,
                                          size: 22,
                                          color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets
                                          .symmetric(
                                          horizontal: 1.0),
                                      child: Text(
                                        item.quantity.toString(),
                                        style: const TextStyle(
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                      style: IconButton.styleFrom(
                                        shape:
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(20.r),
                                        ),
                                        backgroundColor:
                                        AppColors.primary,
                                        padding: EdgeInsets.zero,
                                        minimumSize:
                                        Size(15.w, 15.h),
                                      ),
                                      onPressed: () {
                                        _updateProductQuantity(
                                            item,
                                            item.quantity! + 1,
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
                                      Icons.delete_outline),
                                  onPressed: () {
                                    _removeProduct(item.id!);
                                  },
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
            padding: EdgeInsets.all(24.w),
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
                    const Text(
                      'Total Payment',
                      style:
                      TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_totalPayment.toStringAsFixed(0)} EGP',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
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
                      backgroundColor: const Color(0xFF8C4931),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Checkout Now'),
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
