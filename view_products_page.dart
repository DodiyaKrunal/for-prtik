// lib/view_products_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewProductsPage extends StatefulWidget {
  @override
  _ViewProductsPageState createState() => _ViewProductsPageState();
}

class _ViewProductsPageState extends State<ViewProductsPage> {
  List products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    final url = Uri.parse('http://192.168.1.6:5000/products');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        products = jsonDecode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch products.')),
      );
    }
  }

  void _deleteProduct(String barcode) async {
    final url = Uri.parse('http://192.168.1.6:5000/product/$barcode');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product deleted successfully!')),
      );
      _fetchProducts();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Products')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product['name']),
            subtitle: Text('Barcode: ${product['barcode']}\nPurchase Price: ${product['purchase_price']}\nSelling Price: ${product['selling_price']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteProduct(product['barcode']),
            ),
          );
        },
      ),
    );
  }
}
