import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart'; // استيراد مكتبة SharedPreferences
import 'package:jwt_decoder/jwt_decoder.dart';
import 'CartItemModel.dart';

class CartApi {
  static final Dio _dio = Dio();

  // إعداد Dio بإضافة Authorization Header تلقائيًا
  static Future<void> _setAuthHeader() async {
    final prefs = await SharedPreferences.getInstance(); // استخدام SharedPreferences
    final token = prefs.getString('token'); // قراءة التوكين من SharedPreferences
    print('Token: $token'); // طباعة التوكين للتصحيح
    if (token != null && !JwtDecoder.isExpired(token)) {
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('Authorization Header: ${_dio.options.headers["Authorization"]}'); // طباعة الهيدر للتصحيح
    } else {
      _dio.options.headers.remove("Authorization");
      print("Token is either null or expired");
    }
  }

  // إرجاع Basket ID باستخدام userId من التوكن
  static Future<String> _getBasketId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // قراءة التوكين من SharedPreferences
    if (token != null && !JwtDecoder.isExpired(token)) {
      final decodedToken = JwtDecoder.decode(token);
      final userId = decodedToken['nameid']; // ← غير المفتاح إذا اختلف
      return "Basket_$userId";
    }

    return "Basket_Guest";
  }

  // جلب محتويات السلة
  static Future<List<CartItemModel>> getCartItems() async {
    await _setAuthHeader(); // إضافة الهيدر
    final basketId = await _getBasketId();
    try {
      final response = await _dio.get(
        "http://abdoemam.runasp.net/api/Basket/",
        queryParameters: {"BasketId": basketId},
      );
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      final items = response.data['items'] as List<dynamic>;
      return items.map((item) => CartItemModel.fromJson(item)).toList();
    } catch (e) {
      print("Error fetching cart items: $e");
      return [];
    }
  }

  // تحديث السلة
  static Future<void> updateCart(List<CartItemModel> items) async {
    await _setAuthHeader();
    final basketId = await _getBasketId();
    final data = {
      "id": basketId,
      "items": items.map((e) => e.toJson()).toList(),
    };
    try {
      await _dio.post("http://abdoemam.runasp.net/api/Basket/", data: data);
      print("Cart updated successfully");
    } catch (e) {
      print("Error updating cart: $e");
    }
  }

  // حذف عنصر من السلة
  static Future<void> removeItem(String itemName) async {
    final items = await getCartItems();
    items.removeWhere((item) => item.name == itemName);
    await updateCart(items);
  }

  // مسح جميع العناصر من السلة
  static Future<bool> clearCart() async {
    await _setAuthHeader();
    final basketId = await _getBasketId();
    try {
      final response = await _dio.delete(
        "http://abdoemam.runasp.net/api/Basket/",
        queryParameters: {"BasketId": basketId},
      );
      return response.data == true;
    } catch (e) {
      print("Error clearing cart: $e");
      return false;
    }
  }

  // إضافة عنصر إلى السلة
  static Future<bool> addToCart({
    required int id,
    required String name,
    required String pictureUrl,
    required String brand,
    required String type,
    required int price,
    required int quantity,
  }) async {
    try {
      final basketId = await _getBasketId();

      // جلب العناصر الحالية في السلة
      List<CartItemModel> currentItems = await getCartItems();

      // التحقق إذا كان العنصر موجود بالفعل في السلة
      final index = currentItems.indexWhere((item) => item.name == name);

      if (index != -1) {
        // إذا كان العنصر موجود، تحديث الكمية
        currentItems[index].quantity += quantity;
      } else {
        // إذا لم يكن موجود، إضافة العنصر الجديد
        currentItems.add(CartItemModel(
          id: id,
          name: name,
          pictureUrl: pictureUrl,
          brand: brand,
          type: type,
          price: price,
          quantity: quantity,
        ));
      }

      // تحديث السلة
      await updateCart(currentItems);
      return true;
    } catch (e) {
      print("Error adding to cart: $e");
      return false;
    }
  }

  // تحديث الكمية لعنصر في السلة
  static Future<void> updateItemQuantity(String itemName, int newQuantity) async {
    final items = await getCartItems();
    final index = items.indexWhere((item) => item.name == itemName);
    if (index != -1) {
      items[index].quantity = newQuantity;
      await updateCart(items);
    }
  }
}
