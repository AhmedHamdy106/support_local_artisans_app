class CategoryModel {
  final int id;
  final String name;
  final String imageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,  // إذا لم يكن المفتاح موجودًا، تعيين قيمة افتراضية
      name: json['name'] ?? '',  // تعيين قيمة فارغة إذا كان المفتاح مفقودًا
      imageUrl: json['pictureUrl'] ?? '', // تعيين قيمة فارغة إذا كان المفتاح مفقودًا
    );
  }
}
