

import 'package:flutter/material.dart';
import 'package:barcode_scanner_app/view_products_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String barcode = '';
  double purchasePrice = 0.0;
  double sellingPrice = 0.0;

  Future<void> _addProduct() async {
    final url = Uri.parse('http://localhost:4040/Detail/product');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'barcode': barcode,
          'purchase_price': purchasePrice,
          'selling_price': sellingPrice,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewProductsPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product. Error: $e')),
      );print("error:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Name'),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Barcode'),
                onChanged: (value) {
                  setState(() {
                    barcode = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the barcode';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Purchase Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    purchasePrice = double.tryParse(value) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the purchase price';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Selling Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    sellingPrice = double.tryParse(value) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the selling price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addProduct();
                  }
                },
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
