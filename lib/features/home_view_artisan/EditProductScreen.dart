import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'ProductArtistApi.dart';
import 'ProductArtistModel.dart';

class EditProductScreen extends StatefulWidget {
  final ProductArtistModel product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _brandController;
  late TextEditingController _typeController;

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

    String? imageUrl = widget.product.pictureUrl;

    // إذا اختار صورة جديدة، ارفعها
    if (_newImage != null) {
      try {
        imageUrl = await ProductArtistApi.uploadImage(_newImage!.path, [widget.product.category!]);
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
      pictureUrl: imageUrl,
      description: _descriptionController.text,
      brand: _brandController.text,
      type: _typeController.text,
      category: widget.product.category,
    );

    try {
      await ProductArtistApi.updateProduct(widget.product.id!, updatedProduct);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product updated successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update failed: $e")));
    } finally {
      setState(() => _isLoading = false);
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