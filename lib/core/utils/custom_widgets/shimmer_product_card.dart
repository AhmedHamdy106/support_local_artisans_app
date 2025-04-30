import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProductCard extends StatelessWidget {
  const ShimmerProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على اللون الأساسي من الثيم الحالي
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Shimmer.fromColors(
      baseColor: colorScheme.onSurface.withOpacity(0.1), // لون القاعدة
      highlightColor: colorScheme.onSurface.withOpacity(0.05), // لون الهايلايت
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 10.h,
                      width: 80.w,
                      child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.white))),
                  SizedBox(height: 6.h),
                  SizedBox(
                      height: 10.h,
                      width: 120.w,
                      child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.white))),
                  SizedBox(height: 10.h),
                  SizedBox(
                      height: 10.h,
                      width: 60.w,
                      child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.white))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
