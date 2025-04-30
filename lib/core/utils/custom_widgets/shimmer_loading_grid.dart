import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'shimmer_product_card.dart';

class ShimmerLoadingGrid extends StatelessWidget {
  const ShimmerLoadingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على الثيم الحالي
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GridView.builder(
      padding: EdgeInsets.all(8.sp),
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 280,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => const ShimmerProductCard(),
    );
  }
}
