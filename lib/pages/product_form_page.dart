import 'package:flutter/material.dart';
import 'package:lesson81/service/api_service.dart';

class ProductFormPage extends StatefulWidget {
  final Map<String, dynamic>? product;

  const ProductFormPage({Key? key, this.product}) : super(key: key);

  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryIdController;
  late TextEditingController _imagesController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product?['title'] ?? '');
    _priceController = TextEditingController(text: widget.product?['price']?.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.product?['description'] ?? '');
    _categoryIdController = TextEditingController(text: widget.product?['categoryId']?.toString() ?? '');
    _imagesController = TextEditingController(text: widget.product?['images']?.join(', ') ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryIdController.dispose();
    _imagesController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      var product = {
        'title': _titleController.text,
        'price': int.parse(_priceController.text),
        'description': _descriptionController.text,
        'images': _imagesController.text.split(', ').map((e) => e.trim()).toList(),
      };

      if (widget.product != null) {
        await _apiService.updateProduct(widget.product!['id'], product);
      } else {
        await _apiService.createProduct(product);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product != null ? 'Edit Product' : 'Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryIdController,
                decoration: InputDecoration(labelText: 'Category ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imagesController,
                decoration: InputDecoration(labelText: 'Images (comma separated URLs)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter at least one image URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
