import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ProductArtistApi.dart';
import 'ProductArtistModel.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  XFile? _image;
  bool _isLoading = false;

  String? _selectedCategory;
  final List<String> _categories = [
    'GlassBlowing',
    'Woodworking',
    'Pottery',
    'Leather',
    'Weaving'
  ];

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.primary),
                title: Text('التقاط صورة بالكاميرا'),
                onTap: () async {
                  Navigator.of(context).pop();
                  var status = await Permission.camera.request();
                  if (status.isGranted) {
                    final pickedImage = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      setState(() {
                        _image = pickedImage;
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم رفض إذن الكاميرا')),
                    );
                    await openAppSettings();
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.primary),
                title: Text('اختيار صورة من المعرض'),
                onTap: () async {
                  Navigator.of(context).pop();
                  var status = await Permission.mediaLibrary.request();
                  if (status.isGranted || status.isLimited) {
                    final pickedImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {
                        _image = pickedImage;
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم رفض إذن المعرض')),
                    );
                    await openAppSettings();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please select a category")));
        return;
      }

      if (_image == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please select an image")));
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        String imageUrl =
            await ProductArtistApi.uploadImage(_image!.path, _categories);

        final product = ProductArtistModel(
          id: DateTime.now().millisecondsSinceEpoch,
          name: _nameController.text,
          pictureUrl: imageUrl,
          price: double.tryParse(_priceController.text) ?? 0,
          brand: _brandController.text,
          type: _typeController.text,
          description: _descriptionController.text,
          category: _selectedCategory!,
        );

        await ProductArtistApi.addProduct(product);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Product added successfully")));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to add product: $e")));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Product'),
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nameController, 'Product Name'),
              _buildTextField(_priceController, 'Product Price',
                  keyboardType: TextInputType.number),
              _buildTextField(_descriptionController, 'Product Description'),
              _buildTextField(_brandController, 'Product Brand'),
              _buildTextField(_typeController, 'Product Type'),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                label: Text(
                  'Pick Product Image',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(height: 10.0),
              if (_image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(File(_image!.path), height: 150),
                ),
              const SizedBox(height: 24.0),
              _isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(
                          'Add Product',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }
}
