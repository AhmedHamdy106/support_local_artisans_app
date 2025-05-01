import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'ProductArtistApi.dart';
import 'ProductArtistModel.dart';

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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt,
                    color: Theme.of(context).primaryColor),
                title: Text('pick_camera'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color)),
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
                      SnackBar(
                          content: Text('camera_permission_denied'.tr(),
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error))),
                    );
                    await openAppSettings();
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library,
                    color: Theme.of(context).primaryColor),
                title: Text('pick_gallery'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color)),
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
                      SnackBar(
                          content: Text('gallery_permission_denied'.tr(),
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error))),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("select_category_error".tr(),
                style: TextStyle(color: Theme.of(context).colorScheme.error))));
        return;
      }

      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("select_image_error".tr(),
                style: TextStyle(color: Theme.of(context).colorScheme.error))));
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

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("product_added_success".tr(),
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color))));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${"product_added_error".tr()}: $e",
                style: TextStyle(color: Theme.of(context).colorScheme.error))));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('add_product'.tr()),
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24.sp),
        backgroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nameController, 'product_name'.tr()),
              _buildTextField(_priceController, 'product_price'.tr(),
                  keyboardType: TextInputType.number),
              _buildTextField(
                  _descriptionController, 'product_description'.tr()),
              _buildTextField(_brandController, 'product_brand'.tr()),
              _buildTextField(_typeController, 'product_type'.tr()),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'select_category'.tr(),
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
                    value == null ? 'select_category_error'.tr() : null,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image, color: Colors.white),
                label: Text(
                  'pick_product_image'.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                  ? CircularProgressIndicator(color: theme.primaryColor)
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(
                          'add_product'.tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 16),
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
            value == null || value.isEmpty ? '${'enter'.tr()} $label' : null,
      ),
    );
  }
}
