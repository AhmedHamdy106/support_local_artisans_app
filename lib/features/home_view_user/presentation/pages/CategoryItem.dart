import 'package:flutter/material.dart';
import 'package:support_local_artisans/features/CategoriesScreen/CategoryProductScreen.dart';

class CategoryItem extends StatelessWidget {
  final String name;
  final String imageUrl;

  CategoryItem(this.name, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access current theme

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (_, animation, __) =>
                CategoryProductsScreen(categoryName: name),
            transitionsBuilder: (_, animation, __, child) {
              const beginOffset = Offset(0.0, 0.1);
              const endOffset = Offset.zero;
              final tween = Tween(begin: beginOffset, end: endOffset);
              final fadeTween = Tween<double>(begin: 0, end: 1);

              return SlideTransition(
                position:
                animation.drive(tween.chain(CurveTween(curve: Curves.easeInOut))),
                child: FadeTransition(
                  opacity: animation.drive(fadeTween),
                  child: child,
                ),
              );
            },
          ),
        );
      },
      child: Container(
        width: 80,
        margin: EdgeInsets.only(right: 8),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                color: theme.textTheme.bodyLarge?.color, // Use text color from theme
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
