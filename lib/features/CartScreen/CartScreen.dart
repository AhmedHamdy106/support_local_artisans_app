import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('token');

      if (authToken == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Auth token not found. Please log in.';
        });
        return;
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(authToken);
      final String? userId = decodedToken[
          "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"]; // استخدم نفس المفتاح هنا
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'User ID not found in token.';
        });
        return;
      }

      const String baseUrl =
          'http://abdoemam.runasp.net'; // تأكد من الـ Base URL
      final Dio dio = Dio();
      const String path = '/api/Basket/'; // استخدم الـ userId اللي استخرجته

      final Response response = await dio.get(
        baseUrl + path,
        options: Options(
          headers: <String, dynamic>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Cart Response Body: ${response.data}'); // عشان تشوف شكل البيانات
        final dynamic responseData = response.data;
        if (responseData != null && responseData['items'] is List) {
          final List<dynamic> itemsData = responseData['items'];
          try {
            final List<BasketItem> fetchedItems =
                itemsData.map((item) => BasketItem.fromJson(item)).toList();
            setState(() {
              cartItems = fetchedItems;
              _isLoading = false;
            });
          } catch (e) {
            print('Error parsing cart items: $e');
            setState(() {
              _isLoading = false;
              _errorMessage = 'Error parsing cart data.';
            });
          }
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Invalid cart data format.';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Failed to load cart data. Status code: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred while loading cart data: $error';
      });
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
        title: const Text('Cart Screen'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: AppColors.primary,
            ))
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : cartItems.isEmpty
                  ? const Center(child: Text('Your cart is empty.'))
                  : ListView.builder(
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
                                  borderRadius: BorderRadius.circular(
                                      12.0), // هنا بتحدد درجة الكيرف، ممكن تغير الرقم ده
                                  child: SizedBox(
                                    width: 80.0,
                                    height: 80.0,
                                    child: Image.network(
                                      item.pictureUrl ??
                                          'https://via.placeholder.com/80',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 40.0);
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width: 16.0), // مسافة بين الصورة والكلام
                                Expanded(
                                  // عشان الكلام ياخد باقي المساحة
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name ?? "",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text('${item.price} EGP',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 2.0),
                                      Text('Quantity: ${item.quantity}'),
                                      // ممكن تضيف هنا أي تفاصيل تانية
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // هنا المفروض نعمل عملية الدفع
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
