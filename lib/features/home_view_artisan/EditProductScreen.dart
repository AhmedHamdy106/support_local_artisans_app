import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'ProductArtistApi.dart';
import 'ProductArtistModel.dart';

class EditProductScreen extends StatefulWidget {

   ProductArtistModel product;

   EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _brandController;
  late TextEditingController _typeController;
  late TextEditingController _categoryController; // New controller for category

  XFile? _newImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _descriptionController = TextEditingController(text: widget.product.description);
    _brandController = TextEditingController(text: widget.product.brand);
    _typeController = TextEditingController(text: widget.product.type);
    _categoryController = TextEditingController(text: widget.product.category); // Initialize category controller
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _newImage = picked;
      });
    }
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    // تحقق من وجود الـ category
    if (_categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Category is required")),
      );
      setState(() => _isLoading = false);
      return;
    }

    String? imageUrl = widget.product.pictureUrl;

    // إذا اختار صورة جديدة، ارفعها
    if (_newImage != null) {
      try {
        // رفع الصورة باستخدام الـ API
        imageUrl = await ProductArtistApi.uploadImage(
          _newImage!.path,
          [_categoryController.text], // إرسال الـ category مع الصورة
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image upload failed")));
        setState(() => _isLoading = false);
        return;
      }
    }

    final updatedProduct = ProductArtistModel(
      id: widget.product.id,
      name: _nameController.text,
      price: double.tryParse(_priceController.text) ?? 0,
      pictureUrl: imageUrl, // صورة جديدة إذا تم تحميلها
      description: _descriptionController.text,
      brand: _brandController.text,
      type: _typeController.text,
      category: _categoryController.text, // استخدام الـ category الذي تم إدخاله
    );

    try {
      // ربط الـ API لتحديث المنتج
      await ProductArtistApi.updateProduct(widget.product.id!, updatedProduct);

      // إعادة تحميل المنتجات بعد التعديل
      await _loadUpdatedProducts();

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product updated successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update failed: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadUpdatedProducts() async {
    // إعادة تحميل المنتجات من الـ API بعد التحديث
    try {
      final updatedProducts = await ProductArtistApi.getMerchantProducts();
      setState(() {
        // هنا تقوم بتحديث قائمة المنتجات المعروضة في واجهة المستخدم بعد التحديث
        widget.product = updatedProducts.firstWhere((product) => product.id == widget.product.id);
      });
    } catch (e) {
      print("Failed to load updated products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _newImage != null
                  ? Image.file(File(_newImage!.path), height: 180)
                  : Image.network(widget.product.pictureUrl!, height: 180,
                  errorBuilder: (_, __, ___) => Icon(Icons.image)),
            ),
            SizedBox(height: 12),
            Text("Tap image to change", textAlign: TextAlign.center),
            SizedBox(height: 20),
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: _priceController, decoration: InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
            TextField(controller: _descriptionController, decoration: InputDecoration(labelText: "Description")),
            TextField(controller: _brandController, decoration: InputDecoration(labelText: "Brand")),
            TextField(controller: _typeController, decoration: InputDecoration(labelText: "Type")),
            TextField(controller: _categoryController, decoration: InputDecoration(labelText: "Category")), // New field for category
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text("Save Changes"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }
}
