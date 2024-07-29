import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lesson81/pages/product_form_page.dart';
import 'package:lesson81/service/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService _apiService = ApiService();
  late Future<Response> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _apiService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product API App'),
      ),
      body: FutureBuilder<Response>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List products = snapshot.data!.data;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(products[index]['title']),
                  subtitle: Text('\$${products[index]['price']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          bool? result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductFormPage(product: products[index]),
                            ),
                          );
                          if (result == true) {
                            setState(() {
                              _productsFuture = _apiService.getProducts();
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _apiService.deleteProduct(products[index]['id']);
                          setState(() {
                            _productsFuture = _apiService.getProducts();
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No products found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductFormPage(),
            ),
          );
          if (result == true) {
            setState(() {
              _productsFuture = _apiService.getProducts();
            });
          }
        },
        tooltip: 'Add Product',
        child: Icon(Icons.add),
      ),
    );
  }
}
