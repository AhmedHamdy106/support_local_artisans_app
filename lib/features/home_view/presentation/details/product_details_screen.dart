import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import '../../models/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product? product;

  const ProductDetailsScreen({super.key,  this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // تنفيذ منطق البحث
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // الانتقال إلى صفحة العربة
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(
                      widget.product!.pictureUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      height: 300.h, // تأكد من تحديد ارتفاع مطابق للحاوية
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.broken_image));
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product!.name,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'EGP ${widget.product?.price}',
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                "Brand : ${widget.product?.brand.toString()}",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                "Type : ${widget.product?.type.toString()}",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              // 3. معلومات البيع والتقييم
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      '${3200} Sold',
                      style: TextStyle(
                          fontSize: 12.sp, color: Colors.grey.shade600),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4.w),
                  Text(
                    '${4.8} (${750})',
                    style:
                        TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              // 4. الوصف
              Text(
                'Description',
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                widget.product!.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 24.h),
              // 5. الحجم (Size)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   children: widget.product.sizes!.map((size) {
                  //     final isSelected =
                  //         widget.product.sizes!.indexOf(size) ==
                  //             2; // مثال لاختيار حجم افتراضي
                  //     return Padding(
                  //       padding: EdgeInsets.only(right: 8.w),
                  //       child: InkWell(
                  //         onTap: () {
                  //           // منطق اختيار الحجم
                  //         },
                  //         child: Container(
                  //           width: 32.w,
                  //           height: 32.h,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(8.r),
                  //             color: isSelected
                  //                 ? AppColors.primary
                  //                 : Colors.grey.shade200,
                  //             border: Border.all(color: Colors.grey.shade300),
                  //           ),
                  //           alignment: Alignment.center,
                  //           child: Text(
                  //             size.toString(),
                  //             style: TextStyle(
                  //               color:
                  //                   isSelected ? Colors.white : Colors.black,
                  //               fontWeight: FontWeight.w500,
                  //               fontSize: 14.sp,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),
                  SizedBox(height: 16.h),
                ],
              ),

              // 6. اللون (Color)
              // if (widget.product.colors != null &&
              //     widget.product.colors!.isNotEmpty)
              //   Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Color',
              //         style: Theme.of(context)
              //             .textTheme
              //             .subtitle1
              //             ?.copyWith(fontWeight: FontWeight.bold),
              //       ),
              //       SizedBox(height: 8.h),
              //       Row(
              //         children: widget.product.colors!.map((color) {
              //           final isSelected =
              //               widget.product.colors!.indexOf(color) ==
              //                   1; // مثال لاختيار لون افتراضي
              //           return Padding(
              //             padding: EdgeInsets.only(right: 8.w),
              //             child: InkWell(
              //               onTap: () {
              //                 // منطق اختيار اللون
              //               },
              //               child: Container(
              //                 width: 32.w,
              //                 height: 32.h,
              //                 decoration: BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   color: colorFromString(
              //                       color), // دالة لتحويل اسم اللون إلى Color
              //                   border: Border.all(
              //                     color: isSelected
              //                         ? AppColors.primary
              //                         : Colors.transparent,
              //                     width: 2.w,
              //                   ),
              //                 ),
              //                 child: isSelected
              //                     ? const Icon(Icons.check,
              //                         color: Colors.white, size: 18)
              //                     : null,
              //               ),
              //             ),
              //           );
              //         }).toList(),
              //       ),
              //       SizedBox(height: 32.h),
              //     ],
              //   ),

              // 7. السعر الإجمالي وزر الإضافة إلى العربة (في الأسفل)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total price',
                        style: TextStyle(
                            fontSize: 14.sp, color: Colors.grey.shade600),
                      ),
                      Text(
                        'EGP ${widget.product?.price}',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // منطق الإضافة إلى العربة
                    },
                    icon: const Icon(
                      Icons.add_shopping_cart_outlined,
                      color: Colors.white,
                    ),
                    label: const Text('Add to cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة لتحويل اسم اللون إلى كائن Color (تحتاج إلى تنفيذها بناءً على بياناتك)
  Color colorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'coral':
        return Colors.teal;
      default:
        return Colors.grey; // لون افتراضي
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
