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
  String? _selectedCategory; // المتغير اللي هيخزن الـ category المختار
  List<String> _categories = [
    'Glass',
    'Leather',
    'PotteryAndCeramics',
    'WeavingAndTextiles',
    'Wood'
  ]; // قائمة الـ categories
  XFile? _newImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _brandController = TextEditingController(text: widget.product.brand);
    _typeController = TextEditingController(text: widget.product.type);
    _selectedCategory = widget.product.category; // Initialize selected category
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

    // تحقق من اختيار الـ category
    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a category")),
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
          [_selectedCategory!], // إرسال الـ category المختار مع الصورة
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Image upload failed")));
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
      category: _selectedCategory!, // استخدام الـ category المختار
    );

    try {
      // ربط الـ API لتحديث المنتج
      await ProductArtistApi.updateProduct(widget.product.id!, updatedProduct);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product updated successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Update failed: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access current theme

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor, // Use theme background color
      appBar: AppBar(
        title: const Text(
          "Edit Product",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: theme.primaryColor, // Use primary color from theme
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: SizedBox(
                        height: 180.0,
                        child: _newImage != null
                            ? Image.file(
                                File(_newImage!.path),
                                fit: BoxFit
                                    .cover, // عشان الصورة تغطي المساحة المحددة
                              )
                            : Image.network(
                                widget.product.pictureUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.image),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text("Tap image to change",
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                            color: theme.textTheme.bodyLarge
                                ?.color), // Use text color from theme
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: theme
                                  .primaryColor), // Use primary color from theme
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: theme
                                  .primaryColor), // Use primary color from theme
                        ),
                      )),
                  SizedBox(height: 10),
                  TextField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: "Price",
                        labelStyle: TextStyle(
                            color: theme.textTheme.bodyLarge
                                ?.color), // Use text color from theme
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: theme
                                  .primaryColor), // Use primary color from theme
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: theme
                                  .primaryColor), // Use primary color from theme
                        ),
                      ),
                      keyboardType: TextInputType.number),
                  SizedBox(height: 10),
                  TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: TextStyle(
                            color: theme.textTheme.bodyLarge
                                ?.color), // Use text color from theme
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: theme
                                  .primaryColor), // Use primary color from theme
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: theme
                                  .primaryColor), // Use primary color from theme
                        ),
                      )),
                  SizedBox(height: 10),
                  TextField(
                      controller: _brandController,
                      decoration: InputDecoration(
                        labelText: "Brand",
                        labelStyle: TextStyle(
                            color: theme.textTheme.bodyLarge
                                ?.color), // Use text color from theme
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: theme
                                  .primaryColor), // Use primary color from theme
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: theme
                                  .primaryColor), // Use primary color from theme
                        ),
                      )),
                  SizedBox(height: 10),
                  TextField(
                      controller: _typeController,
                      decoration: InputDecoration(
                        labelText: "Type",
                        labelStyle: TextStyle(
                            color: theme.textTheme.bodyLarge
                                ?.color), // Use text color from theme
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: theme
                                  .primaryColor), // Use primary color from theme
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: theme
                                  .primaryColor), // Use primary color from theme
                        ),
                      )),
                  SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Category',
                      labelStyle: TextStyle(
                          color: theme.textTheme.bodyLarge
                              ?.color), // Use text color from theme
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                    ),
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category,
                            style: TextStyle(
                                color: theme.textTheme.bodyLarge
                                    ?.color)), // Use text color from theme
                      );
                    }).toList(),
                    validator: (value) =>
                        value == null ? 'Please select a category' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            theme.primaryColor), // Use primary color from theme
                  ),
                ],
              ),
      ),
    );
  }
}
